Feature: View Leaderboard
  In order to judge my (and others) performace
  As a trader
  I want to see a list of the best performing traders


Scenario: Leaderboard Users List
  Given I have users named Sammy, Jimmy
  When I go to the leaderbard
  Then I should see "Sammy"
	And I should see "Jimmy"




  




# Feature: Manage Articles
# 	In order to make a blog
# 	As an author
# 	I want to create and manage articles
# 	
# 	Scenario: Articles List
# 	  Given I have articles titled Pizza, Breadsticks
# 	  When I go to the list of articles
# 	  Then I should see "Pizza"
# 	  And I should see "Breadsticks"
# 	
# 	
# 	
