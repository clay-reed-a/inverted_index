class AddSectionToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :section, :string
  end
end
