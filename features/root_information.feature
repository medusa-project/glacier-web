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

  Scenario: Get list of archives for a given root
    Given the root with path '123/456' has archives with fields:
      | id | count | size  |
      | 2  | 102   | 12345 |
      | 4  | 302   | 43993 |
    When I request the list of archives for the root with path '123/456'
    Then the JSON response at "path" should be "123/456"
    And the JSON response at "archives/2/count" should be 102
    And the JSON response at "archives/2/size" should be 12345
    And the JSON response at "archives/4/count" should be 302
    And the JSON response at "archives/4/size" should be 43993