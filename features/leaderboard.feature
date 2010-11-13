Feature: Leaderboard
  In order to value
  As a role
  I want feature



	Scenario: View users with no trades should display amount of cash held by users
	  Given I have users named Sammy with 20.25
	  When I go to the leaderboard
	  Then I should see "Sammy"
		And I should see "$20.25"


	Scenario: View users on leaderboard
	  Given I have users named Sammy, John
	  When I go to the leaderboard
	  Then I should see "Sammy"
	   And I should see "John"




  
