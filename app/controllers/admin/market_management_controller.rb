class Admin::MarketManagementController < ApplicationController
  def index
    @markets = Market.all
  end 

  def new
    @market = Market.new
  end
  
  
  def create
    # todo: needs test
    @market = Market.new(params[:market])
    if @market.save
      redirect_to @market, :notice => 'Successfully created market'
    else
      render :action => 'new'
    end
  end

  def close
  end

  def edit
  end

end
