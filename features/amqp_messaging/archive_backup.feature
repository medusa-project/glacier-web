Feature: AMQP messaging for archive backup
  In order to backup files for archives
  As glacier web
  I want to be able to send and receive AMQP messages

  Background:
    Given the root with path '123/456' exists
    And the root with path '123/456' has archives with fields:
      | id |
      | 1  |

  Scenario: Send message requesting backup of an archive
    Given the archive backup job for the archive with id '1' is in state 'send_request'
    When I run the backup job for the archive with id '1'
    Then the outgoing amqp queue should have a message with fields:
      | action        | backup        |
      | archive_id    | 1             |
      | root_path     | 123/456       |
      | manifest_name | archive_1.txt |
    And the archive backup job for the archive with id '1' should be in state 'await_response'

  Scenario: Receive message on completion of archive backup
    Given the archive backup job for the archive with id '1' is in state 'await_response'
    And the incoming amqp queue has a message with fields:
      | action            | backup            |
      | archive_id        | 1                 |
      | root_path         | 123/456           |
      | manifest_name     | archive_1.txt     |
      | bag_manifest_name | archive_bag_1.txt |
      | amazon_archive_id | some_long_string  |
      | status            | success           |
    When I process the incoming amqp queue
    Then the archive backup job for the archive with id '1' should be in state 'process_response'
    And the archive backup job for the archive with id '1' should have a stored message

  Scenario: Receive message with error for archive backup
    Given the archive backup job for the archive with id '1' is in state 'await_response'
    And the incoming amqp queue has a message with fields:
      | action        | backup             |
      | archive_id    | 1                  |
      | root_path     | 123/456            |
      | manifest_name | archive_1.txt      |
      | status        | error              |
      | error_message | some error message |
    When I process the incoming amqp queue
    Then the admin should receive an email with subject 'Glacier error' matching 'some error message'
    And the archive backup job for the archive with id '1' should be in state 'await_response'
