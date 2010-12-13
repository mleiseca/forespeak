Given /^I have markets named (.+)$/ do |markets|
  markets.split(', ').each do |market|
    outcomes = [Outcome.create(:description => 'Placeholder', :start_price => 100)]
    new_market = Market.create(:name => market, :start_date => '12/13/2010', :outcomes => outcomes)
    if not new_market.save
      fail "Couldn't save market: " + market + " " + new_market.errors.to_s
    end
  end 
  
end
