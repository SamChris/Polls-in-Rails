class User  <  ActiveRecord::Base

  attr_accessible :user_name

  validates :user_name, uniqueness: true, presence: true

  # has_many(
  #
  #
  #
  #
  # )
  #



end