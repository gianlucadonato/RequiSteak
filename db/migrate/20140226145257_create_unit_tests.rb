class CreateUnitTests < ActiveRecord::Migration
  def change
    create_table :unit_tests do |t|
      t.string :title
      t.boolean :status
      t.text :description

      t.timestamps
    end
  end
end
