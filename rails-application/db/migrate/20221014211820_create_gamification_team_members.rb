class CreateGamificationTeamMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :gamification_team_members do |t|
      t.string :team_name
      t.string :user_id
      t.decimal :ratio

      t.timestamps
    end
  end
end
