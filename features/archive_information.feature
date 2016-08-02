Feature: Archive information
  In order to know what is being backed up
  As a client
  I want to request a information about archives

  Background:
    Given the root with path '123/456' exists
    And the root with path '123/456' has archives with fields:
      | id | count | size  |
      | 2  | 102   | 12345 |
      | 4  | 302   | 43993 |

  Scenario: Get a list of all archives
    When I request the list of archives
    Then the JSON should have the following:
      | 0/id        | 2         |
      | 0/count     | 102       |
      | 0/size      | 12345     |
      | 0/root/path | "123/456" |
      | 1/id        | 4         |
      | 1/count     | 302       |
      | 1/size      | 43993     |
      | 1/root/path | "123/456" |

  Scenario: Get information about a specific archive
    When I request the archive with id 2
    Then the JSON should have the following:
      | id        | 2         |
      | count     | 102       |
      | size      | 12345     |
      | root/path | "123/456" |