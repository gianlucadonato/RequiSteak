class AddSubtitleToUseCase < ActiveRecord::Migration
  def change
  	add_column :use_cases, :subtitle, :string
  end
end
