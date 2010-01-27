Given /^I am at the Scrapers page$/ do
  visit "/scrapers"
end

Given /^I am at the New Scraper page$/ do
  visit "/scrapers/new"
end

Given /^I am at the Parsers page$/ do
  visit "/parsers"
end

Given /^I am at the New Parser page$/ do
  visit "/parsers/new"
end

When /^I search for "(.*)"$/ do |postcode_code|
  When "I fill in \"q\" with \"#{postcode_code}\""
  And 'I press "Look up"'
end