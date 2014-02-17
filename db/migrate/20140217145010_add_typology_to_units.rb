class AddTypologyToUnits < ActiveRecord::Migration
  def change
  	add_column :units, :typology, :string, default: "class"
  end
end