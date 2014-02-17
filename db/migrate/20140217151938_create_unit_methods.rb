class CreateUnitMethods < ActiveRecord::Migration
  def change
    create_table :unit_methods do |t|
      t.string :name, null: false
      t.string :visibility, default: "public"
      t.boolean :isQuery, default: false
      t.string :return_type
      t.text :description

      t.timestamps
    end
  end
end
