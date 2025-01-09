import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:path/path.dart';
import 'package:playbook_generator/src/constant_reader_utils.dart';
import 'package:source_gen/source_gen.dart'
    show LibraryReader, TypeChecker, defaultFileHeader;

class PlaybookBuilder implements Builder {
  const PlaybookBuilder(this._config);

  static const _playbookUrl = 'package:playbook/playbook.dart';
  static const _defaultInput = 'lib/**.dart';
  static const _defaultOutput = 'generated_playbook.dart';

  final Map<String, dynamic> _config;
  String get _input => _config['input'] as String? ?? _defaultInput;
  String get _output => _config['output'] as String? ?? _defaultOutput;

  @override
  Map<String, List<String>> get buildExtensions => {
        r'$lib$': [_output],
      };

  @override
  FutureOr<void> build(BuildStep buildStep) async {
    final storyAssets = buildStep.findAssets(Glob(_input));
    final storyFunctions = <Method>[];

    await for (final input in storyAssets) {
      final storyLibrary = await buildStep.resolver.libraryFor(input);
      final storyLibraryReader = LibraryReader(storyLibrary);

      final scenarioCodes = _createScenarioCodes(storyLibraryReader);
      if (scenarioCodes.isEmpty) continue;

      final storyTitle = _findStoryTitle(storyLibraryReader);
      storyFunctions.add(
        _createStoryFunction(
          storyTitle,
          scenarioCodes,
          storyLibraryReader,
        ),
      );
    }

    final storiesLibrary = Library(
      (b) => b
        ..body.addAll([
          _createPlaybookGetter(),
          _createStoriesGetter(storyFunctions),
          ...storyFunctions,
        ]),
    );
    final emitter = DartEmitter(
      allocator: Allocator.simplePrefixing(),
      orderDirectives: true,
      useNullSafetySyntax: true,
    );
    final content = DartFormatter().format(
      '''
$defaultFileHeader

${storiesLibrary.accept(emitter)}
''',
    );
    await buildStep.writeAsString(_outputAssetId(buildStep), content);
  }

  List<Code> _createScenarioCodes(LibraryReader storyLibraryReader) {
    final uri = storyLibraryReader.element.librarySource.uri.toString();

    const generatedScenarioTypeChecker = TypeChecker.fromUrl(
      'package:playbook/src/generate_scenario.dart#GenerateScenario',
    );
    final generatedScenarioCodes = storyLibraryReader
        .annotatedWith(generatedScenarioTypeChecker)
        .where((e) {
      const w = 'Widget';
      const bc = 'BuildContext';

      final element = e.element;
      if (!element.isPublic) return false;
      if (element is ClassElement) {
        return (element.unnamedConstructor?.isDefaultConstructor ?? false) &&
            element.allSupertypes.any(
              (s) => s.getDisplayString() == w,
            );
      } else if (element is FunctionElement) {
        final firstParam =
            element.parameters.firstOrNull?.type.getDisplayString();
        return element.parameters.length <= 1 &&
            (firstParam == null || firstParam == bc) &&
            element.returnType.getDisplayString() == w;
      } else {
        return false;
      }
    }).map(
      (e) {
        final annotation = e.annotation;
        final element = e.element;
        final title = annotation.read('title');
        final titleParam = title.isString
            ? title.stringValue
            : element.displayName.replaceFirst(r'$', '').replaceAll('_', ' ');
        return Code.scope((a) {
          final layout = constantReaderToSource(annotation.read('layout'), a);
          final builder = a(refer(element.displayName, uri));
          final String scenarioName;
          final String childBuilder;

          if (element is FunctionElement && element.parameters.isNotEmpty) {
            scenarioName = 'Scenario.builder';
            childBuilder = 'builder: $builder';
          } else {
            scenarioName = 'Scenario';
            childBuilder = 'child: $builder()';
          }
          return '''
${a(refer(scenarioName, _playbookUrl))}(
  '$titleParam',
  layout: $layout,
  $childBuilder,
)''';
        });
      },
    );

    final scenarioCodes = storyLibraryReader.element.topLevelElements
        .whereType<FunctionElement>()
        .where((e) => e.isPublic && e.parameters.isEmpty)
        .expand<Code>(
      (e) {
        final returnTypeString = e.returnType.getDisplayString();
        final scenarioRefer = refer(e.displayName, uri);
        if (returnTypeString == 'Scenario') {
          return [scenarioRefer([]).code];
        } else if (returnTypeString == 'List<Scenario>') {
          return [Code.scope((a) => '...${a(scenarioRefer)}()')];
        } else {
          return [];
        }
      },
    );
    return <Code>[...generatedScenarioCodes, ...scenarioCodes];
  }

  Method _createStoryFunction(
    String storyTitle,
    List<Code> scenarioCodes,
    LibraryReader storyLibraryReader,
  ) {
    final storyRefer = refer('Story', _playbookUrl);
    final name = storyLibraryReader.element.source.uri.pathSegments
        .skip(1)
        .map((e) => '\$${e.split('.').first}')
        .join();
    final storyFunction = Method(
      (b) => b
        ..returns = storyRefer
        ..name = '_$name\$Story'
        ..body = storyRefer.call([
          literalString(storyTitle),
        ], {
          'scenarios': literalList(scenarioCodes),
        }).code,
    );
    return storyFunction;
  }

  Method _createStoriesGetter(List<Method> storyMethods) {
    final bodyExpression =
        literalList(storyMethods.map((e) => refer('${e.name}()')));
    return Method(
      (b) => b
        ..name = 'stories'
        ..type = MethodType.getter
        ..returns = TypeReference(
          (b) => b
            ..symbol = 'List'
            ..types.add(refer('Story', _playbookUrl).type),
        )
        ..body = bodyExpression.code,
    );
  }

  Method _createPlaybookGetter() {
    final playbookRefer = refer('Playbook', _playbookUrl);
    return Method(
      (b) => b
        ..name = 'playbook'
        ..type = MethodType.getter
        ..returns = playbookRefer
        ..body = playbookRefer.call([], {
          'stories': refer('stories'),
        }).code,
    );
  }

  String _findStoryTitle(LibraryReader storyLibraryReader) {
    late final fullName = storyLibraryReader.element.source.fullName;
    final storyTitle = storyLibraryReader.element.topLevelElements
        .whereType<VariableElement>()
        .firstWhere(
          (e) => e.name == 'storyTitle',
          orElse: () => throw StateError(
            'Library $fullName need define the story title.',
          ),
        )
        .computeConstantValue()
        ?.toStringValue();
    if (storyTitle == null) {
      throw StateError('Library $fullName storyTitle must be const.');
    }
    return storyTitle;
  }

  AssetId _outputAssetId(BuildStep buildStep) {
    return AssetId(
      buildStep.inputId.package,
      join('lib', _output),
    );
  }
}
