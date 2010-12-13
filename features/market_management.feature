Feature: Market management
  In order to support traders with new markets
  As a administrator
  I want to create, close and edit markets


Scenario: Administration Market List
  Given I have markets named MarketA, MarketB
  When I go to the market administration list
  Then I should see "MarketA"
	And I should see "MarketB"

Scenario: Outcomes start prices should add to 100
	When I go to the new market page
	And I fill in "market_name" with "New Market Name"
	And I fill in "market_start_date" with "12/13/2010"
	And I fill in "market_outcomes_attributes_0_description" with "Outcome1" 
	And I fill in "market_outcomes_attributes_0_start_price" with "15" 
	
	And I fill in "market_outcomes_attributes_1_description" with "Outcome2" 
	And I fill in "market_outcomes_attributes_1_start_price" with "40" 

	And I fill in "market_outcomes_attributes_2_description" with "Outcome3" 
	And I fill in "market_outcomes_attributes_2_start_price" with "25" 
	And I press "Create"
  Then I should see "prohibited this record from being saved"
	And I should see "Outcome start prices must total 100"



# Scenario: Create new market
#   # Given I am logged in as an administrator
#   When I go to the new market page
#   Then I should see "Name:"
# 	And I should see "Start Date:"
# # 
# Scenario: Create a market with outcomes
# 	# Given I am logged in as an administrator
# 	When I go to the new market page
# 	Then I should see "Name:"
# 	And I should see "Start Date:"
# 






  
