class MarketsController < ApplicationController
  
  protect_from_forgery :except=>:index
  
  
  def index
    @markets = Market.find(:all, :conditions => ['end_date is null'])    
  end
  
  def show
    @market = Market.find(params[:id])
    @latest_position_id = ''
    @latest_position_id = @market.position.id if @market.position
    
    # if @market.last_transaction_date
    #      fresh_when :last_modified => @market.last_transaction_date.utc, :etag => @market
    #    end
  end
  
  def updates
    @market = Market.find(params[:id])
    client_recent_position = Position.find(params[:position_id])
        
    if @market.position and (@market.position == client_recent_position)
      head :not_modified 
      return
    end

    
    @positions = Position.more_recent_positions_for_market(client_recent_position)
    activity = @positions.map{|p| 
    {
      :id => p.id,
      :outcome_id=> p.outcome.id, 
      :user=>p.user.username, 
      :volume => p.delta_user_shares,
      :price => "%0.2f" % p.outcome_price,
      :total_purchased => p.outcome.shares_purchased,
      :date => p.created_at.in_time_zone("Central Time (US & Canada)").strftime("%m/%d/%Y %H:%M:%S")
    }}
    
    prices = @market.outcomes.map{|o| {:id => o.id, :sell_price=>"%0.2f" % o.sell_price, :buy_price=>"%0.2f" % o.buy_price} }
    render :json => {
      :activity => activity ,
      :current_outcomes   => prices
    }
      
    if @market.last_transaction_date
      fresh_when(:last_modified => @market.last_transaction_date.utc, :etag => @market.position)
    end
  end

  def sell
    outcome_id = params[:outcome_id]
    outcome = Outcome.find(outcome_id)
    
    current_position = outcome.position_for_user(current_user)
    
    share_count = (params.include? :sell_share_count) ? params[:sell_share_count].to_i : 10

    if share_count < 0
      flash[:error] = "Invalid share count"
      return redirect_to markets_path
    end
    
    if current_position.nil? || (current_position.total_user_shares < share_count)
      flash[:error] = "You don't have any shares to sell"      
      return redirect_to markets_path    
    else
      total_shares = current_position.total_user_shares - share_count
    end
    
    current_price = outcome.sell_price(share_count)
    position = Position.new(
      :outcome => outcome, 
      :user => current_user, 
      :delta_user_shares => -1 * share_count,
      :delta_user_account_value=> 1 * share_count * current_price,
      :total_user_shares => total_shares,
      :direction => :sell,
      :outcome_price => current_price
    )

    if position.save
      logger.info "Created position: " + position.to_s
      current_user.cash = current_user.cash + position.delta_user_account_value
      current_user.save
      flash[:message] = "Sell successful -- %.2f shares @ $%.2f cost %.2f" % 
        [-1 * position.delta_user_shares, position.outcome_price, position.delta_user_account_value]

      clear_caches(outcome)
      
      outcome.market.had_sale(position)
      outcome.market.save
      
      redirect_to outcome.market
    else
      flash[:error] = position.errors
      
      redirect_to outcome.market    
    end
  end
  
  
  def buy
    outcome_id = params[:outcome_id]
    outcome = Outcome.find(outcome_id)
    
    current_position = outcome.position_for_user(current_user)

    share_count = (params.include? :buy_share_count) ? params[:buy_share_count].to_i : 10

    if share_count < 0
      flash[:error] = "Invalid share count"
      return redirect_to markets_path
    end

    total_shares = share_count
    if outcome.shares_available < share_count
      flash[:error] = "There are not enough shares available"
      return redirect_to markets_path    
    end

    if ! current_position.nil?
      total_shares += current_position.total_user_shares
    end
    
    current_price = outcome.buy_price(share_count)
    
    position = Position.new(
      :outcome => outcome, 
      :user => current_user, 
      :delta_user_shares => share_count,
      :delta_user_account_value=> -1 * share_count * current_price,
      :total_user_shares => total_shares,
      :direction => :buy,
      :outcome_price => current_price
      )
    
    if position.save
      logger.info "Created position: " + position.to_s
      current_user.cash = current_user.cash + position.delta_user_account_value
      current_user.save
      flash[:message] = "Buy successful -- %.2f shares @ $%.2f cost %.2f" % 
        [position.delta_user_shares, position.outcome_price, -1 * position.delta_user_account_value]

        outcome.market.had_sale(position)
        outcome.market.save
        
        clear_caches(outcome)
        redirect_to outcome.market
    else
      flash[:error] = position.errors
      
      redirect_to outcome.market
    end
    
  end
  
  private 
  
  def clear_caches(outcome)
    # todo: this should be a sweeper on Position creation instead of a method
    #  see: http://guides.rubyonrails.org/caching_with_rails.html#sweepers
    expire_fragment(
      :controller => "markets", 
      :action => "show", 
      :id=>outcome.market.id, 
      :fragment => "market_#{outcome.market.id}_outcomes")

  end
end
