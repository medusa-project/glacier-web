Feature: Root information
  In order to know what is being backed up
  As a client
  I want to request a list of roots

  Background:
    Given the root with path '123/456' exists
    And the root with path '654/321' exists

  Scenario: Get list of roots
    When I request the list of roots
    Then the JSON should have the following:
      | 0/path | "123/456" |
      | 1/path | "654/321" |

  Scenario: Get list of archives for a given root
    Given the root with path '123/456' has archives with fields:
      | id | count | size  |
      | 2  | 102   | 12345 |
      | 4  | 302   | 43993 |
    When I request the list of archives for the root with path '123/456'
    Then the JSON should have the following:
      | path             | "123/456" |
      | archives/0/id    | 2         |
      | archives/0/count | 102       |
      | archives/0/size  | 12345   |
      | archives/1/id    | 4         |
      | archives/1/count | 302       |
      | archives/1/size  | 43993   |