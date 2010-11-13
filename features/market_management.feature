Feature: Market management
  In order to support traders with new markets
  As a administrator
  I want to create, close and edit markets


Scenario: Administration Market List
  Given I have markets named MarketA, MarketB
  When I go to the market administration list
  Then I should see "MarketA"
	And I should see "MarketB"




  
