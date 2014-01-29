class CreateRequirementsSources < ActiveRecord::Migration
  def change
    create_table :requirements_sources do |t|
    		t.integer :requirement_id
        t.integer :source_id
    end
  end
end
