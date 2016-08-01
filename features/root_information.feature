Feature: Root information
  In order to know what is being backed up
  As a client
  I want to request a list of roots

  Background:
    Given the root with path '123/456' exists
    And the root with path '654/321' exists

  Scenario: Get list of roots
    When I request the list of roots
    Then the JSON response at "0/path" should be "123/456"
    And the JSON response at "1/path" should be "654/321"