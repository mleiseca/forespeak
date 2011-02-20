class MarketsController < ApplicationController
  def index
    @markets = Market.all
  end

  def buy
    outcome_id = params[:outcome_id]
    logger.info "Looking up outcome_id: #{outcome_id}"
    outcome = Outcome.find(outcome_id)
    
    current_position = outcome.position_for_user(current_user)
    
    share_count = 1
    total_shares = share_count
    if ! current_position.nil?
      total_shares += current_position.total_user_shares
    end
    
    position = Position.new(
      :outcome => outcome, 
      :user => current_user, 
      :delta_user_shares => share_count,
      :delta_user_account_value=> -1 * share_count * outcome.current_price,
      :total_user_shares => total_shares,
      :transaction_type => :buy,
      :outcome_price => outcome.current_price + 1
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
