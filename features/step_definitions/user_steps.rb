
Given /^I have users named (.+?)(?: with (.+))?$/ do |usernames,cash_amounts|
  cash_values = cash_amounts.nil? ? nil : cash_amounts.split(', ')
  
  i = 0 
  usernames.split(', ').each do |name|
      user_cash = cash_values.nil? ? 0 : cash_values[i]
      Factory.create(:trader, {:username => name, :cash => user_cash, :email => "#{name}@example.com"})
      
      i = i + 1
  end
end


Given /^I have a confirmed account$/ do
  @user = Factory.create(:trader)
end

Given /^I am logged in as a trader$/ do
  @user = Factory.create(:trader)
  Given "I log in"
end

Given /^I am logged in as an admin$/ do
  @user = Factory.create(:admin)
  Given "I log in"
end

Given /^I log in$/ do
  
  # todo: should probably assert that @user is defined
  visit('login')
  fill_in('Username', :with => @user.username)
  fill_in('Password', :with => @user.password)
  click_button('Create User session')
end



# Given /^I have articles titled (.+)$/ do |titles|
#   titles.split(', ').each do |title|
#     Article.create(:title => title)
#   end
# end
