
Given /^I have users named (.+)$/ do |usernames|
  usernames.split(', ').each do |name|
      Users.create(:name => name)
  end

end


# Given /^I have articles titled (.+)$/ do |titles|
#   titles.split(', ').each do |title|
#     Article.create(:title => title)
#   end
# end
