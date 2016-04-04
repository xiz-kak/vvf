class CreateRewardCodeSequence < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE SEQUENCE reward_code_seq;
    SQL
  end

  def down
    execute <<-SQL
      DROP SEQUENCE reward_code_seq;
    SQL
  end
end
