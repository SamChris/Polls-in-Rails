class Response < ActiveRecord::Base

  attr_accessible :answer_choice_id, :respondent_id

  validates :answer_choice_id, :respondent_id, presence: true
  validate :respondent_has_not_already_answered_question
  validate :respondent_is_not_submitter

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

  def respondent_is_not_submitter
    # submitter_id = self.answer_choice.question.poll.author.id

    if (self.respondent_id == question_submitter.first.id)

      errors[:respondent_id] << "can't respond to its own poll"
      return false
    end
    true
  end



  def respondent_has_not_already_answered_question
    if (existing_responses.count == 1 &&
            existing_responses.first.respondent_id == self.respondent_id)
      errors[:respondent_id] << "can only have one response per question"
      return false
    end
    true
  end

  private

  def existing_responses
    # part a
    question_id = self.answer_choice.question.id

    # Response.find_by_sql(<<-SQL, self.id)
#     SELECT questions.id
#     FROM questions
#     JOIN answer_choices ON answer_choices.question_id = questions.id
#     JOIN responses ON responses.answer_choice_id = answer_choices.id
#     WHERE responses.id = ?

    # part b

    query = <<-SQL
      SELECT responses.*
      FROM responses
      JOIN users ON users.id = responses.respondent_id
      WHERE responses.respondent_id = ?
      AND responses.answer_choice_id IN
        (SELECT answer_choices.id
         FROM answer_choices
         JOIN questions ON questions.id = answer_choices.question_id
         WHERE questions.id = ?)
     SQL

     Response.find_by_sql([query, self.respondent_id, question_id ])

  end

  def question_submitter
    User.select("users.*")
    .joins(authored_polls: {questions: :answer_choices})
    .where("answer_choices.id = ?", self.answer_choice_id)
  end


end