Factory.define :market do |m|
  m.name          "Market 1" 
  m.description   "Market just for testing"
  m.start_date    Time.now
  
  m.after_build { |market|
    market.outcomes << Factory.build(:outcome, :market => market)
  }
  m.after_create { |market|
    market.outcomes.each { |o| o.save! }
  }
  
end