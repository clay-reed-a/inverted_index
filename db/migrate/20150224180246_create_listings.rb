class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.datetime :publication_date
      t.text :summary
      t.text :title
      t.string :url

      t.timestamps null: false
    end
  end
end
