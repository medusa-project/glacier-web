Feature: Root information
  In order to know what is being backed up
  As a client
  I want to request a information about roots

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
      | archives/0/size  | 12345     |
      | archives/1/id    | 4         |
      | archives/1/count | 302       |
      | archives/1/size  | 43993     |

  Scenario: Get list of archives for a given root and file
    Given the root with path '123/456' has archives with fields:
      | id |
      | 2  |
      | 3  |
      | 4  |
    And the root with path '123/456' has files with fields:
      | id | path   |
      | 10 | file_1 |
      | 11 | file_2 |
      | 12 | file_3 |
    And the archive with id '2' contains the files with paths:
      | file_1 | file_2 |
    And the archive with id '4' contains the files with paths:
      | file_2 | file_3 |
    When I request the list of archives for the root with path '123/456' and file with path 'file_2'
    Then the JSON should have the following:
      | root_path     | "123/456" |
      | file_path     | "file_2"  |
      | archives/0/id | 2         |
      | archives/1/id | 4         |
    And the JSON at "archives" should be an array
    And the JSON at "archives" should have 2 entries

