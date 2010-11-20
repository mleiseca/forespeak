require 'spec_helper'

describe Admin::MarketManagementController do
  render_views

  # describe "POST 'close'" do
  #    it "should be successful" do
  #      post 'close', :id => 2
  #      response.should be_success
  #    end
  #  end

  describe "GET 'edit'" do
    it "should be successful" do
      get 'edit', :id => 2
      response.should be_success
    end
  end
  
  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end
  
  describe "POST 'create'" do
    it "should be successful" do
      post 'create'
      response.should be_redirect
    end
  end

end
