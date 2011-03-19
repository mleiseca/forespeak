Given /^I have markets named (.+)$/ do |market_names|
  market_names.split(', ').each do |market_name|
    Factory.create(:market, :name => market_name)
  end   
end
