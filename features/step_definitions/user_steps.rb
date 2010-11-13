
Given /^I have users named (.+?)(?: with (.+))?$/ do |usernames,cash_amounts|
  cash_values = cash_amounts.nil? ? nil : cash_amounts.split(', ')
  
  i = 0 
  usernames.split(', ').each do |name|
      user_cash = cash_values.nil? ? 0 : cash_values[i]
      User.create(:name => name, :cash => user_cash)
      i = i + 1
  end
end


# Given /^I have articles titled (.+)$/ do |titles|
#   titles.split(', ').each do |title|
#     Article.create(:title => title)
#   end
# end
