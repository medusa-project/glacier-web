Feature: AMQP messaging for archive backup
  In order to backup files for archives
  As glacier web
  I want to be able to send and receive AMQP messages

  Background:
    When the root with path '123/456' has archives with fields:
      | id |
      | 1  |

  Scenario: Send message requesting backup of an archive
    When PENDING

  Scenario: Receive message on completion of archive backup
    When PENDING

  Scenario: Receive message with error for archive backup
    When PENDING
