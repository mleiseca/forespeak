Feature: Markets display
  In order to see prediction generated by the system
  As a trader
  I want to see the states of the markets

Scenario: Market list
  Given I have markets named Market1, Market2
  And I am logged in as a trader
  When I go to the market list
  Then I should see "Market1"
	And I should see "Market2"


 

  
