Feature: User Authentication

  Scenario: User signs up with valid credentials
    Given I launch the app
    And I fill the "Email" field with "testuser@example.com"
    And I fill the "Password" field with "SuperSecure123"
    When I tap the "Sign Up" button
    Then I expect to see the text "User registered!"
