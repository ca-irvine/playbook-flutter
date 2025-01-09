import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:generator_app/generated_playbook.dart';
import 'package:playbook_snapshot/playbook_snapshot.dart';

Future<void> main() async {
  testWidgets('Take snapshots', (tester) async {
    await playbook.run(
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
