class Admin::MarketManagementController < ApplicationController
  
  before_filter :require_admin_user
  
  def index
    @markets = Market.all
  end 

  def new
    @market = Market.new
    3.times { @market.outcomes.build }
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
    outcome = Outcome.find(params[:outcome_id])
    
    market = outcome.market
    if market.nil? || ! market.end_date.nil?
      # todo: test
      flash[:error] = "Market has already be closed"
    end
    
    positions = outcome.all_user_positions
    
    positions.each do |position|
      user = position.user
      user.cash = user.cash + (position.total_user_shares * 100)
      user.save
    end
    
    market.end_date = Time.now
    market.save

    redirect_to market_management_index_path
  end
  
end
