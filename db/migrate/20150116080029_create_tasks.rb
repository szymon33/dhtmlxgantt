class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :text
      t.date :start_date
      t.integer :duration
      t.float :progress
      t.integer :sortorder
      t.integer :parent

      t.timestamps
    end
  end
end
