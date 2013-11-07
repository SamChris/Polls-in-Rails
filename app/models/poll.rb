class Poll < ActiveRecord::Base

  attr_accessible :title, :author_id

  validates :title, :author_id, presence: true


end