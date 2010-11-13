class Admin::MarketManagementController < ApplicationController
  def index
    @markets = Market.all
  end 

  def create
  end

  def close
  end

  def edit
  end

end
