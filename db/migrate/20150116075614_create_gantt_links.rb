class CreateGanttLinks < ActiveRecord::Migration
  def change
    create_table :gantt_links do |t|
      t.integer :source_id
      t.integer :target_id
      t.string  :gtype # 'type' is a reserver word in RoR

      t.timestamps
    end
    add_index :gantt_links, :source_id
    add_index :gantt_links, :target_id
  end
end
