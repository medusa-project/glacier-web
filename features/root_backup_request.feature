Feature: Root backup request
  In order to ensure prompt backups of new content
  As the client
  I want to be able manually to request that a given root is backed up

  Background:
    Given the root with path '123/456' exists

  Scenario: Request root backup when no job exists yet
    Given there is no backup job for the root with path '123/456'
    When I request backup for the root with path '123/456'
    Then the backup job for the root with path '123/456' should have priority 'high'
    And the JSON at "status" should be "CREATED"

  Scenario: Request root backup when job currently exists
    When I request backup for the root with path '123/456'
    Then the backup job for the root with path '123/456' should have priority 'high'
    And the JSON at "status" should be "EXISTS"

  Scenario: Request root backup for root that doesn't exist
    When I request backup for the root with path '654/321'
    Then the JSON at "status" should be "BAD ROOT"