import 'package:playbook/playbook.dart';
import 'package:simple_app/bar/bar.dart';

Scenario twoLineText() {
  return const Scenario(
    'TwoLine',
    child: BarWidget(text: 'TextTextText\nTextText'),
  );
}

Scenario emptyText() {
  return const Scenario('Empty', child: BarWidget(text: ''));
}

List<Scenario> variousText() {
  return ['Text 1', 'Text2']
      .map(
        (e) => Scenario(e, child: BarWidget(text: e)),
      )
      .toList();
}

Story barStory() {
  return Story(
    'BarWidget',
    scenarios: [
      twoLineText(),
      emptyText(),
      ...variousText(),
    ],
  );
}
