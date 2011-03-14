Factory.define :outcome do |o|
  o.description   "Outcome 1"
  o.market { |a| a.association(:market) }
end