import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

StepDefinitionGeneric GivenUserIsOnLoginPage() {
  return given1<String>(
    'I am on the {string} page',
    (pageName, _) async {
      // Implement navigation
    },
  );
}
