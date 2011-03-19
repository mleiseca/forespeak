Feature: Leaderboard
  In order to value
  As a role
  I want feature

	Scenario: View users with no trades should display amount of cash held by users
	  Given I have users named Sammy with 20.25
    And I am logged in as a trader
	  When I go to the leaderboard
	  Then I should see "Sammy"
		And I should see "20.25" 
		# todo: should be $20.25. not sure how to concatenate values with haml


	Scenario: View users on leaderboard
	  Given I have users named Sammy, John
    And I am logged in as a trader
	  When I go to the leaderboard
	  Then I should see "Sammy"
	   And I should see "John"




  
