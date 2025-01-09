import 'package:flutter/material.dart';
import 'package:playbook/playbook.dart';
import 'package:playbook_ui/playbook_ui.dart';
import 'package:simple_app/bar/bar.story.dart';
import 'package:simple_app/foo/foo_widget.story.dart';
import 'package:simple_app/image/asset_image.story.dart';
import 'package:simple_app/page/page.story.dart';
import 'package:simple_app/scrollable/scrollable.story.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var _isDark = false;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PlaybookGallery(
      title: 'Sample app',
      searchTextController: controller,
      onCustomActionPressed: () => setState(() {
        _isDark = !_isDark;
      }),
      lightTheme: _isDark ? ThemeData.dark() : ThemeData.light(),
      playbook: Playbook(
        stories: [
          barStory(),
          fooWidgetStory(),
          assetImageStory(),
          homePageStory(),
          scrollableStory(),
        ],
      ),
    );
  }
}
