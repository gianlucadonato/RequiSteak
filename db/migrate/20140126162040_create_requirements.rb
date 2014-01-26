class CreateRequirements < ActiveRecord::Migration
  def change
    create_table :requirements do |t|
      t.string :system, null: false
      t.string :typology, null: false
      t.string :priority, null: false
      t.string :hierarchy, null: false
      t.string :title, null: false
      t.boolean :status, default: 0
      t.text :description
      t.string :ancestry

      t.timestamps
    end
    add_index :requirements, :ancestry
  end
end
