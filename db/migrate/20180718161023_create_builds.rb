class CreateBuilds < ActiveRecord::Migration[5.2]
  def change
    create_table :builds do |t|
      t.integer :user_id
      t.string :champion
      t.string :items

      t.timestamps
    end
  end
end
