Feature: Missing Test Action
  As a Business Analyst
  I want to be warned if I missed an action to test
  so that all my scenarios actually stimulate the system and provoke a behavior

  Background:
    Given a file named "lint.rb" with:
      """
      $LOAD_PATH << '../../lib'
      require 'gherkin_lint'

      linter = GherkinLint.new
      linter.enable %w(MissingTestAction)
      linter.analyze 'lint.feature'
      exit linter.report

      """

  Scenario: Warns for missing action
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should fail with exactly:
      """
      MissingTestAction - No 'When'-Step
        lint.feature (2): Test.A

      """

  Scenario: Passes for valid feature
    Given a file named "lint.feature" with:
      """
      Feature: Test
        Scenario: A
          Given setup
          When action
          Then verification
      """
    When I run `ruby lint.rb`
    Then it should pass with exactly:
      """

      """