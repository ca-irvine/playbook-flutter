import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playbook/playbook.dart';

Widget assetImage() => Image.asset('assets/flutter.png');

Story assetImageStory() {
  return Story(
    'AssetImage',
    scenarios: [
      Scenario(
        'AssetImage',
        child: assetImage(),
      ),
      const Scenario(
        'MaterialIcon',
        child: Icon(Icons.access_alarm),
      ),
      const Scenario(
        'CupertinoIcon',
        child: Icon(CupertinoIcons.alarm),
      ),
    ],
  );
}
