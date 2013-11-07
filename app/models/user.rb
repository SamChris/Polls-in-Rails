class User  <  ActiveRecord::Base

  attr_accessible :user_name

  validates :user_name, uniqueness: true, presence: true

  has_many(
    :authored_polls,
    class_name: 'Poll',
    foreign_key: :author_id,
    primary_key: :id
  )

  has_many(
    :responses,
    class_name: "Response",
    foreign_key: :respondent_id,
    primary_key: :id
  )


  def completed_polls
    query = <<-SQL
      SELECT DISTINCT p.*
      FROM polls p
      WHERE p.id NOT IN
        (SELECT DISTINCT p1.id
        FROM polls p1
        WHERE p1.id IN
           (SELECT DISTINCT q1.poll_id
            FROM questions q1
            WHERE q1.id NOT IN
              (SELECT DISTINCT questions.id
               FROM questions
               INNER JOIN answer_choices ac1 ON ac1.question_id = questions.id
               INNER JOIN responses r2 ON r2.answer_choice_id = ac1.id
               WHERE r2.respondent_id = ? )))
     SQL

    Poll.find_by_sql([query, self.id])
  end

  def incompleted_polls

    query = <<-SQL
    SELECT DISTINCT px.*
    FROM polls px
    INNER JOIN questions qx ON qx.poll_id = px.id
    INNER JOIN answer_choices acx ON acx.question_id = qx.id
    INNER JOIN responses rx ON rx.answer_choice_id = acx.id
    WHERE rx.respondent_id = ?
    AND px.id IN
      (SELECT DISTINCT p1.id
      FROM polls p1
      WHERE p1.id IN
         (SELECT DISTINCT q1.poll_id
          FROM questions q1
          WHERE q1.id NOT IN
            (SELECT DISTINCT questions.id
             FROM questions
             INNER JOIN answer_choices ac1 ON ac1.question_id = questions.id
             INNER JOIN responses r2 ON r2.answer_choice_id = ac1.id
             WHERE r2.respondent_id = ? )))
    SQL

    Poll.find_by_sql([query, self.id, self.id])
  end

end