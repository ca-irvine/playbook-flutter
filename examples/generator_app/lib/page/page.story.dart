import 'package:flutter/material.dart';
import 'package:generator_app/page/page.dart';
import 'package:playbook/playbook.dart';

const storyTitle = 'HomePage';

@GenerateScenario()
Widget myPage() => const HomePage(title: 'Home Page');
