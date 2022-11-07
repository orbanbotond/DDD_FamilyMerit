# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :members_info do
      column :email, String, null: false
      column :uuid, String, primary_key: true
    end
  end
end
