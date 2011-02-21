class MarketsController < ApplicationController
  def index
    @markets = Market.all
  end

  def sell
    outcome_id = params[:outcome_id]
    outcome = Outcome.find(outcome_id)
    
    current_position = outcome.position_for_user(current_user)
    
    share_count = 10
    
    if current_position.nil? || (current_position.total_user_shares < share_count)
      # todo: how to show general error?
      # position.errors[:user] << "you have insufficient shares"
      # @position = position
      index
      render :action => 'index'
      return 
    else
      total_shares = current_position.total_user_shares - share_count
    end
    
    current_price = outcome.current_price
    position = Position.new(
      :outcome => outcome, 
      :user => current_user, 
      :delta_user_shares => -1 * share_count,
      :delta_user_account_value=> 1 * share_count * current_price,
      :total_user_shares => total_shares,
      :direction => :sell,
      :outcome_price => current_price
      # :outcome_price_post_transaction => determine_new_price(outcome)
    )

    if position.save
      logger.info "Created position: " + position.to_s
      current_user.cash = current_user.cash + position.delta_user_account_value
      current_user.save
      flash[:notice] = "Sell successful."
      redirect_to markets_path    
    else
      logger.info "Errors creating position: " + position.errors.to_s
      @position = position
      
      index
      render :action => 'index'
    end
  end
  
  def buy
    outcome_id = params[:outcome_id]
    outcome = Outcome.find(outcome_id)
    
    current_position = outcome.position_for_user(current_user)
    
    share_count = 10
    total_shares = share_count
    if outcome.shares_available < share_count
      # todo: how to show general error?
      index
      render :action => 'index'
      return
    end

    if ! current_position.nil?
      total_shares += current_position.total_user_shares
    end
    
    current_price = outcome.current_price
    
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
      flash[:notice] = "Buy successful."
      redirect_to markets_path    
    else
      logger.info "Errors creating position: " + position.errors.to_s
      @position = position
      
      index
      render :action => 'index'
    end
    
  end
end
