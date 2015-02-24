class AddLocationToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :location, :integer
  end
end
