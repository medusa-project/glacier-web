Feature: AMQP messaging for file information
  In order to get filesystem information about files for a root
  As glacier web
  I want to be able to send and receive AMQP messages

  Background:
    Given there are roots with fields:
      | id | path    |
      | 1  | 123/456 |

  Scenario: Send message requesting information on a root's file tree
    Given the root with path '123/456' has a backup job in state 'request_manifest'
    When I run the backup job for the root with path '123/456'
    Then the outgoing amqp queue should have a message with fields:
      | action        | file_info       |
      | root_path     | 123/456         |
      | manifest_name | file_info_1.txt |

  Scenario: Receive message with information on a root's file tree
    Given the incoming amqp queue has a message with fields:
      | action        | file_info       |
      | root_path     | 123/456         |
      | manifest_name | file_info_1.txt |
      | status        | success         |
    And the root with path '123/456' has a backup job in state 'wait_manifest'
    When I process the incoming amqp queue
    Then the backup job for the root with path '123/456' should be in state 'process_manifest'
    And the root backup job for the root with path '123/456' should have a stored message

  Scenario: Receive error message after requesting information on a root's file tree
    Given the incoming amqp queue has a message with fields:
      | action        | file_info                  |
      | root_path     | 123/456                    |
      | manifest_name | file_info_1.txt            |
      | status        | error                      |
      | error_message | Unknown error of some kind |
    And the root with path '123/456' has a backup job in state 'wait_manifest'
    When I process the incoming amqp queue
    Then the backup job for the root with path '123/456' should be in state 'wait_manifest'
    And the admin should receive an email with subject 'Glacier error' matching 'Unknown error of some kind'

