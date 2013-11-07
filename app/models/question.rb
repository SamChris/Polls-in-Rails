class Question < ActiveRecord::Base

  attr_accessible :text, :poll_id

  validates :poll_id, :text, presence: true



end