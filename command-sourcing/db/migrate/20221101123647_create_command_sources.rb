# frozen_string_literal: true

ROM::SQL.migration do
  change do
    create_table :command_sources do
      primary_key :id    
      column :properties, JSON, null: false
    end
  end
end
