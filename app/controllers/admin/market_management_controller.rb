class Admin::MarketManagementController < ApplicationController
  def index
    @markets = Market.all
  end 

  def new
    @market = Market.new
  end
  
  def show 
  end 
  
  
  def create
    # todo: needs test
    @market = Market.new(params[:market])
    if @market.save
      flash[:notice]  = 'Successfully created market'
      redirect_to market_management_path(@market)
    else
      render :action => 'new'
    end
  end

  def close
  end

  def edit
  end

end
