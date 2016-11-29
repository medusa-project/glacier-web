Feature: Create archives
  In order to group files together for backup
  As the system
  I want to be able to create archives from files associated with a backup

  Background:
    Given the root with path '123/456' exists
    And the root with path '123/456' has a backup job in state 'create_archives'

  Scenario: Create archives from file information
    Given the root with path '123/456' has files with fields:
      | path           | size  | needs_archiving |
      | unchanged_file | 123   | false           |
      | file_1         | 1000  | true            |
      | file_2         | 20000 | true            |
      | file_3         | 8000  | true            |
      | file_4         | 4000  | true            |
      | file_5         | 5000  | true            |
      | file_6         | 500   | true            |
      | file_7         | 2000  | true            |
    When I create archives for the backup job for the root with path '123/456'
    Then the root with path '123/456' should have archives with fields:
      | count | size  |
      | 1     | 20000 |
      | 2     | 13000 |
      | 4     | 7500  |
    And the root with path '123/456' has a backup job in state 'finish'
    And there should be 3 archive backup jobs