class CreateDataFields < ActiveRecord::Migration
  def change
    create_table :data_fields do |t|
      t.string :name, null: false
      t.string :visibility, default: "public"
      t.string :data_type
      t.text :description
      t.integer :unit_id

      t.timestamps
    end
  end
end
