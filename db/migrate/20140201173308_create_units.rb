class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :title, null:false
      t.text :description
      t.text :use
      t.integer :class_id
      t.integer :component_id
      t.string :ancestry

      t.timestamps
    end
    add_index :units, :ancestry
  end
end
