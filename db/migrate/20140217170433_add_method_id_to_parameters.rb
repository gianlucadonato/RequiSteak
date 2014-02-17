class AddMethodIdToParameters < ActiveRecord::Migration
  def change
  	add_column :parameters, :unit_method_id, :integer
  end
end
