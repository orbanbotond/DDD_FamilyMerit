class CreateTimeHarvestReports < ActiveRecord::Migration[7.0]
  def change
    create_table :time_harvest_reports do |t|
      t.integer :account_id
      t.string :user_name
      t.integer :total_time_gained
      t.integer :total_time_consumed
      t.integer :balance

      t.timestamps
    end
  end
end
