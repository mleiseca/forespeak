describe "Market Management routing" do
  it "routes /admin/markets/:id/close" do
    { :post => "/admin/markets/2/close" }.should route_to(
      :controller => "admin/market_management",
      :action => "close",
      :id => "2")
  end
    # 
    # it "routes /admi/markets/:id? " do
    #   { :get => "/widgets/1/edit" }.should_not be_routable
    # end
    
  it "routes /admin/markets" do
    { :post => "/admin/markets"}.should route_to(
      :controller => 'admin/market_management',
      :action => 'create')
  end
end