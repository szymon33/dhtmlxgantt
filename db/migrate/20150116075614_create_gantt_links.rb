class CreateGanttLinks < ActiveRecord::Migration
  def change
    create_table :gantt_links do |t|
      t.integer :source
      t.integer :target
      t.string  :gtype # type is a reserver word in RoR

      t.timestamps
    end
  end
end
