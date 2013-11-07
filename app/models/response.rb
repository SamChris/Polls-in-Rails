class Response < ActiveRecord::Base

  attr_accessible :answer_choice_id, :respondent_id

  validates :answer_choice_id, :respondent_id, presence: true

  belongs_to(
    :answer_choice,
    class_name: 'AnswerChoice',
    foreign_key: :answer_choice_id,
    primary_key: :id
  )

  belongs_to(
    :respondent,
    class_name: 'User',
    foreign_key: :respondent_id,
    primary_key: :id
  )


end