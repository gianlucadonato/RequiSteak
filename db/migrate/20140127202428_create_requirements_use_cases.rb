class CreateRequirementsUseCases < ActiveRecord::Migration
  def change
    create_table :requirements_use_cases do |t|
    		t.integer :requirement_id
        t.integer :use_case_id
    end
    add_index :requirements_use_cases, :requirement_id
    add_index :requirements_use_cases, :use_case_id
  end
end

