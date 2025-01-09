import 'package:flutter/material.dart';
import 'package:generator_app/generated_playbook.dart';
import 'package:playbook_ui/playbook_ui.dart';

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
      title: 'Generator app',
      searchTextController: controller,
      checkeredColor: null,
      onCustomActionPressed: () => setState(() {
        _isDark = !_isDark;
      }),
      lightTheme: _isDark ? ThemeData.dark() : ThemeData.light(),
      playbook: playbook,
    );
  }
}
