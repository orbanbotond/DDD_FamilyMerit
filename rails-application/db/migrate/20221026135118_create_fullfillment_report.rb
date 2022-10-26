class CreateFullfillmentReport < ActiveRecord::Migration[7.0]
  def change
    create_table :fullfillment_reports do |t|
      t.string :fullfillment_id
      t.string :transaction_id
      t.boolean :payment_authorized
      t.boolean :payment_captured
      t.boolean :payment_released
      t.boolean :delivered
      t.boolean :not_delivered

      t.timestamps
    end
  end
end
