class Micropost < ActiveRecord::Base
  attr_accessible :content
  
  belongs_to :user

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}

  default_scope order: 'microposts.created_at DESC'

  def self.from_users_followed_by user
  	where 'user_id IN 
  				(SELECT followed_id FROM relationships
  					WHERE follower_id = :user_id) 
  			OR user_id = :user_id', user_id: user
  end
end
