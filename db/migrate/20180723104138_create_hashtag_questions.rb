class CreateHashtagQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :hashtag_questions do |t|
      t.belongs_to :hashtag, index: true
      t.belongs_to :question, index: true
      t.timestamps
    end
  end
end
