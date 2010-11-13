Feature: Leaderboard
  In order to value
  As a role
  I want feature


Scenario: View users on leaderboard
  Given I have users named Sammy, John
  When I go to the leaderboard
  Then I should see "Sammy"
   And I should see "John"



  
