Feature: Scrape single URI
  In order to save contents at URI
  as a user
  I want to execute a scrape job

  Scenario: get to new scrape job form
    Given I am at the Scrape Jobs page
    When I follow "New scrape_job"
    Then I should see "Name:"
    And I should see "Uri:"
    And I should see "Pdftotext layout:"
