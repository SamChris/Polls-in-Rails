class Question < ActiveRecord::Base

  attr_accessible :text, :poll_id

  validates :poll_id, :text, presence: true

  belongs_to(
    :poll,
    class_name: "Poll",
    foreign_key: :poll_id,
    primary_key: :id
  )

  has_many(
    :answer_choices,
    class_name: "AnswerChoice",
    foreign_key: :question_id,
    primary_key: :id
  )

  def results

    results = self.answer_choices
                  .includes(:responses)
                  .select("*")
                  .joins(:responses)
                  .where("answer_choices.question_id = ?", self.id)
                  .group("answer_choices.text")
                  .count

    choice_counts = Hash.new(0)
    self.answer_choices.each do |answer_choice|
         choice_counts[answer_choice.text] = 0
       end

    choice_counts.merge(results)

  end
end