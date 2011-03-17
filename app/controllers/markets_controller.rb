class MarketsController < ApplicationController
  
  protect_from_forgery :except=>:index
  
  
  def index
    @markets = Market.find(:all, :conditions => ['end_date is null'])    
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
      
      redirect_to markets_path    
    else
      flash[:error] = position.errors
      
      redirect_to markets_path    
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

      redirect_to markets_path    
    else
      flash[:error] = position.errors
      redirect_to markets_path    
    end
    
  end
end
