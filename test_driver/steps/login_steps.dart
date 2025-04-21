import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';
import 'package:flutter_test/flutter_test.dart';

StepDefinitionGeneric givenILaunchTheApp() {
  return given<FlutterWorld>('I launch the app', (context) async {
    await Future.delayed(Duration(seconds: 1));
  });
}

StepDefinitionGeneric fillFieldStep() {
  return when2<String, String, FlutterWorld>(
    'I fill the {string} field with {string}',
    (fieldKey, inputValue, context) async {
      final finder = find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            (widget.decoration?.labelText?.toLowerCase() ==
                fieldKey.toLowerCase()),
      );
      await context.world.driver.tap(finder);
      await context.world.driver.enterText(inputValue);
      await context.world.driver.waitUntilNoTransientCallbacks();
    },
  );
}

StepDefinitionGeneric tapButtonStep() {
  return when1<String, FlutterWorld>(
    'I tap the {string} button',
    (buttonText, context) async {
      final finder = find.text(buttonText);
      await context.world.driver.tap(finder);
      await context.world.driver.waitUntilNoTransientCallbacks();
    },
  );
}

StepDefinitionGeneric expectTextStep() {
  return then1<String, FlutterWorld>(
    'I expect to see the text {string}',
    (expectedText, context) async {
      final finder = find.text(expectedText);
      expect(finder, findsOneWidget);
    },
  );
}

List<StepDefinitionGeneric> loginSteps = [
  givenILaunchTheApp(),
  fillFieldStep(),
  tapButtonStep(),
  expectTextStep(),
];
