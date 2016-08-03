Feature: Process manifest
  In order to update the list of files for a root
  As the system
  I want to be able to process a manifest file for the current file system state

  Background:
    Given the root with path '123/456' exists
    And the root with path '123/456' has a backup job in state 'wait_manifest'
    And the root with path '123/456' has manifest 'manifest.txt' and file information:
      | path      | size | fs_mtime | db_mtime |
      | unchanged | 100  | 1        | 1        |
      | changed   | 200  | 2        | 1        |
      | new       | 300  | 3        |          |
      | deleted   | 400  |          | 2        |

  @current
  Scenario: Process manifest
    When I process the manifest for the backup job for the root with path '123/456'
    Then the backup job for the root with path '123/456' should be in state 'create_archives'
    And there should be files with fields:
      | path      | mtime | needs_archiving | deleted |
      | unchanged | 1     | false           | false   |
      #| changed   | 2     | true            | false   |
      #| new       | 3     | true            | false   |
      #| deleted   | 2     | false           | true    |