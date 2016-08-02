Feature: Root creation
  In order to preserve content
  As a user
  I want to be able to ask for roots to be created and backups begun on them

  Scenario: Create a new root
    Given the storage path '123/456' exists
    When I create a root with path '123/456'
    Then the JSON should have the following:
      | status    | "CREATED" |
      | root/path | "123/456" |

  Scenario: Attempt to create a root that already exists
    Given the root with path '123/456' exists
    When I create a root with path '123/456'
    Then the JSON should have the following:
      | status    | "EXISTS"  |
      | root/path | "123/456" |

  Scenario: Attempt to create a root that doesn't have a corresponding directory
    When I create a root with path '123/456'
    Then the JSON should have the following:
      | status  | "NOT_CREATED"                          |
      | message | "The storage directory does not exist" |