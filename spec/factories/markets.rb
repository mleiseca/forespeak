Factory.define :market do |m|
  m.name          "Market 1" 
  m.description   "Market just for testing"
  m.start_date    Time.now
  
  m.after_build { |market|
    market.outcomes << Factory.build(:outcome, {:description => "outcome 1", :market => market})
    market.outcomes << Factory.build(:outcome, {:description => "outcome 2", :market => market})
  }
  m.after_create { |market|
    market.outcomes.each { |o| o.save! }
  }
  
end