class AddUnitTestIdToUnitMethods < ActiveRecord::Migration
  def change
  	add_column :unit_methods, :unit_test_id, :integer
  end
end
