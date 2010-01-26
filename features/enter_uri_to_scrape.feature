Feature: Scrape single URI
  In order to save contents at URI
  as a user
  I want to execute a scrape job

  Scenario: get to new scraper form
    Given I am at the Scrapers page
    When I follow "New scraper"
    Then I should see "Name:"
    And I should see "Uri:"
    And I should see "Pdftotext layout:"
    
  Scenario: create new scraper
    Given I am at the New Scraper page
    When I fill in the following:
      | Name: | Amendments submitted on 11 January 2010                               |
      | Uri:  | http://www.publications.parliament.uk/pa/ld/ldreg/jan10/11january.pdf |
    And I check "Pdftotext layout:"
    And I press "Create"
    Then I should see "Amendments submitted on 11 January 2010"
    And I should see "Scrape now"
