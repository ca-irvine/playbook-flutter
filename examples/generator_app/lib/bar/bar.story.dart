import 'package:generator_app/bar/bar.dart';
import 'package:playbook/playbook.dart';

const storyTitle = 'BarWidget';

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
