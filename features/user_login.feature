Feature: User login
  In order to make trades and view positions
  As a trader
  I want to be able to login


Scenario: Login with confirmed account
  Given I have a confirmed account
  When I log in
  Then I should see "Successfully logged in"
    
  
