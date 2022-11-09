class CreateTransactionReports < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_reports do |t|
      t.string :transaction_id
      t.string :order_id
      t.decimal :amount
      t.string :transaction_type

      t.timestamps
    end
  end
end
