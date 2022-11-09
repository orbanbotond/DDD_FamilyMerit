class CreateQueueJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :dres_rails_queue_jobs do |t|
      t.integer :queue_id, null: false
      t.string  :event_id, null: false
      t.string  :state,    null: false
    end
    add_index :dres_rails_queue_jobs, [:queue_id, :event_id]
  end
end
