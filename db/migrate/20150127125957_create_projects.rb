class CreateProjects < ActiveRecord::Migration
  def change
    add_column :tasks, :project_id, :integer
    add_index :tasks, :project_id

    create_table :projects do |t|
      t.string :name

      t.timestamps
    end
  end
end
