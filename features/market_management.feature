Feature: Market management
  In order to support traders with new markets
  As a administrator
  I want to create, close and edit markets


Scenario: Administration Market List
  Given I have markets named MarketA, MarketB
  When I go to the market administration list
  Then I should see "MarketA"
	And I should see "MarketB"

Scenario: Create new market
  # Given I am logged in as an administrator
  When I go to the new market page
  Then I should see "Name:"
	And I should see "Start Date:"





  
