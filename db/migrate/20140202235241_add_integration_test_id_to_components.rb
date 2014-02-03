class AddIntegrationTestIdToComponents < ActiveRecord::Migration
  def change
  	add_column :components, :integration_test_id, :integer
  end
end
