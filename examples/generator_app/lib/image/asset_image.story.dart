import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playbook/playbook.dart';

const storyTitle = 'AssetImage';

@GenerateScenario()
Widget $AssetImage() => Image.asset('assets/flutter.png');

@GenerateScenario()
Widget $MaterialIcon() => const Icon(Icons.access_alarm);

@GenerateScenario()
Widget $CupertinoIcon() => const Icon(CupertinoIcons.alarm);
