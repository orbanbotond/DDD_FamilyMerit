# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :team_members_info do
      primary_key :id
      column :team_name, String, null: false
      column :user_id, String, null: false
      column :ratio, String, null: false
    end
  end
end
