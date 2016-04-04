class AlterRewardCodeSequence < ActiveRecord::Migration
  def up
    execute <<-SQL
      ALTER SEQUENCE reward_code_seq OWNED BY rewards.code;
      ALTER TABLE rewards ALTER COLUMN code SET DEFAULT nextval('reward_code_seq');
    SQL
  end

  def down
    execute <<-SQL
      ALTER SEQUENCE reward_code_seq OWNED BY NONE;
      ALTER TABLE rewards ALTER COLUMN code SET DEFAULT NULL;
    SQL
  end
end
