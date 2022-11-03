class AddAmountToFullfillmentReports < ActiveRecord::Migration[7.0]
  def change
    add_column :fullfillment_reports, :amount, :integer
  end
end
