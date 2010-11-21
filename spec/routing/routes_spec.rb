describe "Market Management routing" do
  it "routes /admin/markets/:id/close" do
    { :post => "/admin/markets/2/close" }.should route_to(
      :controller => "admin/market_management",
      :action => "close",
      :id => "2")
  end
    
  it "routes /admin/markets" do
    { :post => "/admin/markets"}.should route_to(
      :controller => 'admin/market_management',
      :action => 'create')
  end
  
  it "routes /" do
    { :get => "/"}.should route_to(
      :controller => 'root',
      :action => 'index')
  end
  
end