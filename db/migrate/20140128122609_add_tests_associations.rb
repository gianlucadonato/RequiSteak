class AddTestsAssociations < ActiveRecord::Migration
  def change
  		add_column :requirements, :validation_test_id, :integer
  		add_column :requirements, :system_test_id, :integer
  end
end
