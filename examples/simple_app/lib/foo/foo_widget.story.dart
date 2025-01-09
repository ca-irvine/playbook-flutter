// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:playbook/playbook.dart';

Scenario foo1() {
  return Scenario('Hello', child: Container(color: Colors.blue));
}

Scenario foo2() {
  return Scenario(
    'World',
    alignment: Alignment.topRight,
    child: Center(
      child: Container(width: 200, height: 250, color: Colors.amber),
    ),
  );
}

class Foo3 extends StatelessWidget {
  const Foo3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.amber);
  }
}

class Foo4_Bar extends StatelessWidget {
  const Foo4_Bar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.pink);
  }
}

Widget foo5() => const Text('Foo 5');

Story fooWidgetStory() {
  return Story(
    'FooWidget',
    scenarios: [
      foo1(),
      foo2(),
      const Scenario(
        'foo3foo3',
        layout: ScenarioLayout.sizing(
          ScenarioLayoutFixed(
            100,
          ),
          ScenarioLayoutFixed(
            200,
          ),
        ),
        child: Foo3(),
      ),
      const Scenario(
        'Foo4 Bar',
        layout: ScenarioLayout.fixedH(
          300,
          crossAxisLayout: ScenarioLayoutFill(),
        ),
        child: Foo4_Bar(),
      ),
      Scenario(
        'foo5',
        layout: const ScenarioLayout.fixedV(
          500,
          crossAxisLayout: ScenarioLayoutFixed(
            200,
          ),
        ),
        child: foo5(),
      ),
    ],
  );
}
