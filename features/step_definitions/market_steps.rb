Given /^I have markets named (.+)$/ do |markets|
  markets.split(', ').each do |market|
    Market.create(:name => market)
  end 
  
end
