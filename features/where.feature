Feature: Where clauses
  In order to build queries
  As a developer
  I want to be able to specify where clauses

  Scenario: Equality
    Given there are cats called Jessica and Trevor
    When I query for cats where name equals Jessica
    Then only cats with a name of Jessica are returned
