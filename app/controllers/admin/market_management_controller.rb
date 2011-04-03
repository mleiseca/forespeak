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
    @market.start_date = DateTime.civil(params[:start_date][:year].to_i, 
      params[:start_date][:month].to_i, 
      params[:start_date][:day].to_i,
      params[:start_date][:hour].to_i,
      params[:start_date][:minute].to_i,
      0,
      Rational(-6, 24)
      )
    @market.last_trade_allowed_date = DateTime.civil(params[:last_trade_allowed_date][:year].to_i,
      params[:last_trade_allowed_date][:month].to_i, 
      params[:last_trade_allowed_date][:day].to_i,
      params[:last_trade_allowed_date][:hour].to_i,
      params[:last_trade_allowed_date][:minute].to_i,
      0,
      Rational(-6, 24)
      )
    

    if @market.save
      flash[:notice]  = 'Successfully created market'
      redirect_to market_management_path(@market)
    else
      render :action => 'new'
    end
  end

  def show
    @market = Market.find(params[:id])
  end 
  # todo: needs test....also should be in outcome, not here
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
