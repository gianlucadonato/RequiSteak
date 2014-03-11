class AddWeightToParameters < ActiveRecord::Migration
  def change
  	add_column :parameters, :weight, :integer
  end
end
