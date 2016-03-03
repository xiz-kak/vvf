class CreateRewardContents < ActiveRecord::Migration
  def change
    create_table :reward_contents do |t|
      t.belongs_to :reward, index: true, foreign_key: true
      t.belongs_to :language, index: true, foreign_key: true
      t.string :title
      t.string :image_path
      t.text :description

      t.timestamps null: false
    end
  end
end
