Given /^I am at the Web Resources page$/ do
  visit "/web_resources"
end

Given /^I am at the New Web Resource page$/ do
  visit "/web_resources/new"
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