class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.string :title, null: false
      t.text :description
      t.text :use
      t.text :graph
      t.integer :package_id
      t.string :ancestry

      t.timestamps
    end
    add_index :components, :ancestry
  end
end
