Feature: AMQP messaging for file information
  In order to get filesystem information about files for a root
  As glacier web
  I want to be able to send and receive AMQP messages

  Background:
    Given the root with path '123/456' has manifest 'my-manifest.txt'
    And the root with path '123/456' has a backup job in state 'wait_manifest'

  Scenario: Send message requesting information on a root's file tree
    When I request file information for the root with path '123/456'
    Then the outgoing amqp queue should have a message with fields:
      | type          | file_info       |
      | root_path     | 123/456         |
      | manifest_path | my-manifest.txt |

  Scenario: Receive message with information on a root's file tree
    Given the incoming amqp queue has a message with fields:
      | type          | file_info       |
      | root_path     | 123/456         |
      | manifest_path | my-manifest.txt |
      | status        | success         |
    When I process the incoming amqp queue
    Then the backup job for the root with path '123/456' should be in state 'process_manifest'

  Scenario: Receive error message after requesting information on a root's file tree
    Given the incoming amqp queue has a message with fields:
      | type          | file_info                  |
      | root_path     | 123/456                    |
      | manifest_path | my-manifest.txt            |
      | status        | error                      |
      | error_message | Unknown error of some kind |
    When I process the incoming amqp queue
    Then the backup job for the root with path '123/456' should be in state 'wait_manifest'
    And the admin should receive an email matching 'Unknown error of some kind'

