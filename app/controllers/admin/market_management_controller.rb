class Admin::MarketManagementController < ApplicationController
  def index
    @markets = Market.all
  end 

  def new
    @market = Market.new
  end

  def close
  end

  def edit
  end

end
