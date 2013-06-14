class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.string :regname
      t.string :renumber
      t.references :user

      t.timestamps
    end
    add_index :registrations, :user_id
  end
end
