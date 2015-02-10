class CreateGanttLinks < ActiveRecord::Migration
  def change
    create_table :gantt_links do |t|
      t.belongs_to :project, index: true
      t.references :targetable, polymorphic: true, index: true
      t.references :sourceable, polymorphic: true, index: true
      t.string  :gtype # 'type' is a reserver word in RoR

      t.timestamps null: false
    end
  end
end
