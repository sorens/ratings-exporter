class CreateTitles < ActiveRecord::Migration
  def change
    create_table :titles do |t|
      t.string :user_id
      t.string :name
      t.string :year
      t.string :url
      t.string :rating
      t.string :netflix_id
      t.string :netflix_type
      t.text :data
      t.datetime :viewed_date
      t.integer :exported, :default => 0

      t.timestamps
    end
  end
end
