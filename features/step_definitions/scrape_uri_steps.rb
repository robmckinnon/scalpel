Given /I am at the Scrape Jobs page/ do
  visit "/scrape_jobs"
end

When /^I search for "(.*)"$/ do |postcode_code|
  When "I fill in \"q\" with \"#{postcode_code}\""
  And 'I press "Look up"'
end