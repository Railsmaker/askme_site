class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.references :user, index: true, foreign_key: true
      t.integer :author_id
      t.string :author_name
      t.string :text
      t.string :answer
      t.timestamps
    end
  end
end
