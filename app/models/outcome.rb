class Outcome < ActiveRecord::Base
  validates_presence_of :description
  validates_numericality_of :start_price
  
  has_many :positions
  
  def current_price
    start_price
  end
  
  def position_for_user(user)
    position = Position.last(:conditions => ["outcome_id = ? and user_id = ?", id, user.id])
    logger.info "found position: #{position}"      
    position
    
    # positions = Position.where("outcome_id = ? and user_id = ?", id, user.id).order("created_at desc").limit(1).all
    # 
    # positions.find_each do |position|
    #   logger.info "found position: #{position}"      
    # end 
    
  end
end
