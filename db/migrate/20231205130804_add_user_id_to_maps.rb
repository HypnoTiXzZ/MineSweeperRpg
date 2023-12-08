class AddUserIdToMaps < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :map_id, :integer
  end
end
