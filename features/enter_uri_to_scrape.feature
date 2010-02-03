Feature: Scrape single URI
  In order to save contents at URI
  as a user
  I want to execute a scrape job

  Scenario: get to new web resource form
    Given I am at the Web Resources page
    When I follow "New web resource"
    Then I should see "Name:"
    And I should see "Uri:"
    And I should see "Pdftotext layout:"
    
  Scenario: create new web resource
    Given I am at the New Web Resource page
    When I fill in the following:
      | Name: | Amendments submitted on 11 January 2010                               |
      | Uri:  | http://www.publications.parliament.uk/pa/ld/ldreg/jan10/11january.pdf |
    And I check "Pdftotext layout:"
    And I press "Create"
    Then I should see "Amendments submitted on 11 January 2010"
    And I should see "Scrape now"
