Feature: Process manifest
  In order to update the list of files for a root
  As the system
  I want to be able to process a manifest file for the current file system state

  Background:
    Given there are roots with fields:
      | id | path    |
      | 1  | 123/456 |
    And the root with path '123/456' has a backup job in state 'wait_manifest'
    And the root with path '123/456' has db and manifest file information:
      | path               | size | fs_mtime | db_mtime | deleted |
      | unchanged          | 100  | 1        | 1        | false   |
      | changed            | 200  | 2        | 1        | false   |
      | new                | 300  | 3        |          |         |
      | deleted            | 400  |          | 2        | false   |
      | previously_deleted | 500  | 4        | 2        | true    |

  Scenario: Process manifest
    Given the root with path '123/456' has a backup job in state 'process_manifest'
    When I run the backup job for the root with path '123/456'
    Then the backup job for the root with path '123/456' should be in state 'create_archives'
    And there should be files with fields:
      | path               | mtime | needs_archiving | deleted |
      | unchanged          | 1     | false           | false   |
      | changed            | 2     | true            | false   |
      | deleted            | 2     | false           | true    |
      | new                | 3     | true            | false   |
      | previously_deleted | 4     | true            | false   |