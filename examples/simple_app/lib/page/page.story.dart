import 'package:playbook/playbook.dart';
import 'package:simple_app/page/page.dart';

Story homePageStory() {
  return const Story(
    'HomePage',
    scenarios: [
      Scenario(
        'myPage',
        child: HomePage(title: 'Home Page'),
      ),
    ],
  );
}
