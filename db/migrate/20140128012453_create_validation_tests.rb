class CreateValidationTests < ActiveRecord::Migration
  def change
    create_table :validation_tests do |t|
      t.string :title, null:false
      t.boolean :status
      t.text :description

      t.timestamps
    end
  end
end
