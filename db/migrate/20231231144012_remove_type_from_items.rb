class RemoveTypeFromItems < ActiveRecord::Migration[7.0]
  def change
    remove_column :items, :type, :string
  end
end
