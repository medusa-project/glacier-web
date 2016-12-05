Feature: AMQP messaging
  In order to communicate with other participating systems
  As glacier web
  I want to be able to send and receive AMQP messages

  Scenario: Send message requesting information on a root's file tree
    Given the root with path '123/456' has manifest 'my-manifest.txt'
    When I request file information for the root with path '123/456'
    Then the outgoing amqp queue should have a message with fields:
      | type          | file_info       |
      | root_path     | 123/456         |
      | manifest_path | my-manifest.txt |

  Scenario: Receive message with information on a root's file tree
    Given the root with path '123/456' has manifest 'my-manifest.txt'
    And the root with path '123/456' has a backup job in state 'wait_manifest'
    And the incoming amqp queue has a message with fields:
      | type          | file_info       |
      | root_path     | 123/456         |
      | manifest_path | my-manifest.txt |
      | status        | success         |
    When a file information message is read from the incoming amqp queue
    Then the backup job for the root with path '123/456' should be in state 'process_manifest'

  Scenario: Receive error message after requesting information on a root's file tree
    Given the root with path '123/456' has manifest 'my-manifest.txt'
    And the root with path '123/456' has a backup job in state 'wait_manifest'
    And the incoming amqp queue has a message with fields:
      | type          | file_info                  |
      | root_path     | 123/456                    |
      | manifest_path | my-manifest.txt            |
      | status        | error                      |
      | error_message | Unknown error of some kind |
    When a file information message is read from the incoming amqp queue
    Then the backup job for the root with path '123/456' should be in state 'wait_manifest'
    And the admin should receive an email matching 'Unknown error of some kind'

  Scenario: Send message requesting backup of an archive
    When PENDING

  Scenario: Receive message on completion of archive backup
    When PENDING

  Scenario: Receive message with error for archive backup
    When PENDING
