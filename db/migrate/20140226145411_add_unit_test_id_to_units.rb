class AddUnitTestIdToUnits < ActiveRecord::Migration
  def change
  	add_column :units, :unit_test_id, :integer
  end
end
