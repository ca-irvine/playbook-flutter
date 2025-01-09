import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playbook/playbook.dart';
import 'package:playbook_snapshot/playbook_snapshot.dart';
import 'package:simple_app/bar/bar.story.dart';
import 'package:simple_app/foo/foo_widget.story.dart';
import 'package:simple_app/image/asset_image.story.dart';
import 'package:simple_app/page/page.story.dart';
import 'package:simple_app/scrollable/scrollable.story.dart';

Future<void> main() async {
  testWidgets('Take snapshots', (tester) async {
    await Playbook(
      stories: [
        barStory(),
        fooWidgetStory(),
        assetImageStory(),
        homePageStory(),
        scrollableStory(),
      ],
    ).run(
      const Snapshot(
        devices: [
          SnapshotDevice.iPhoneSE2nd,
        ],
      ),
      tester,
      (widget, device) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'Roboto',
            platform: device.platform,
          ),
          home: widget,
        );
      },
    );
  });
}
