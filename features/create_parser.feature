Feature: Create Parser
  In order to parse result of a scrape run
  as a user
  I want to create a parser

  Scenario: get to new parser form
    Given I am at the Parsers page
    When I follow "New parser"
    Then I should see "Name:"
    And I should see "Uri pattern:"
    And I should see "Parser file:"
    
  Scenario: create new parser
    Given I am at the New Parser page
    When I fill in the following:
      | Name:        | Lords Amendments                                    |
      | Uri pattern: | ^www.publications.parliament.uk\/pa\/ld\/ldreg\/.+$ |
      | Parser file: |  lords_amendments_parser.rb                         |
    And I press "Create"
    Then I should see "Lords Amendments"
    And I should see "Parse now"
