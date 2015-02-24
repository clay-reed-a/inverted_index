class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :listing_id
      t.integer :word_id

      t.timestamps null: false
    end
  end
end
