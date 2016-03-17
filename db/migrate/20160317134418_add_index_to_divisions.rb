class AddIndexToDivisions < ActiveRecord::Migration
  def change
    add_index :divisions, [:code, :val], unique: true
  end
end
