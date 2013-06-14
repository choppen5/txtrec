class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.string :from
      t.string :to

      t.timestamps
    end
  end
end
