Feature: Process archive upload message
  In order to track amazon archives
  As the system
  I want to record amazon archive ids returned by the file system interactor

  Scenario: Process archive upload
    Given the root with path '123/456' exists
    And the root with path '123/456' has archives with fields:
      | id |
      | 1  |
    And the archive backup job for the archive with id '1' is in state 'process_response'
    And the archive with id '1' has manifest files
    And the archive backup job for the archive with id '1' has message with fields:
      | action            | backup            |
      | archive_id        | 1                 |
      | root_path         | 123/456           |
      | manifest_path     | archive_1.txt     |
      | bag_manifest_path | archive_bag_1.txt |
      | amazon_archive_id | some_long_string  |
      | status            | success           |
    When I run the backup job for the archive with id '1'
    Then the archive backup job for the archive with id '1' should be in state 'finish'
    And the archive with id '1' should have amazon archive id 'some_long_string'
    And the archive with id '1' should not have manifest files
    And the archive with id '1' should have archived manifest files