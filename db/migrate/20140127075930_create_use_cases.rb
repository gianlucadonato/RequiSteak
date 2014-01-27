class CreateUseCases < ActiveRecord::Migration
  def change
    create_table :use_cases do |t|
      t.string :system, null: false
      t.string :hierarchy, null: false
      t.string :title
      t.string :primary_actors, null: false
      t.string :secondary_actors
      t.text :description
      t.string :precondition, null: false
      t.string :postcondition, null: false
      t.text :main_flow
      t.text :alternative_flow
      t.text :inclusion
      t.text :extension
      t.text :graph
      t.string :ancestry

      t.timestamps
    end
    add_index :use_cases, :ancestry
  end
end
