class AddUnitIdToUnitMethods < ActiveRecord::Migration
  def change
 		add_column :unit_methods, :unit_id, :integer
  end
end
