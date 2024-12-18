class CreateChallenges < ActiveRecord::Migration[8.0]
  def change
    create_table :challenges do |t|
      t.string :title,null:false
      t.text :description,null:false
      t.date :start_date,null:false
      t.date :end_date,null:false

      t.timestamps
    end
  end
end
