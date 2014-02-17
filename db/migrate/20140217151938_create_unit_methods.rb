class CreateUnitMethods < ActiveRecord::Migration
  def change
    create_table :unit_methods do |t|
      t.string :name
      t.string :visibility
      t.boolean :isQuery
      t.string :return_type
      t.text :description

      t.timestamps
    end
  end
end
