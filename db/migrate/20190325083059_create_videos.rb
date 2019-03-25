class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.integer :duration 
      t.string :name
      t.belongs_to :customer 

      t.timestamps
    end

    change_column :videos, :duration, :bigint
  end
end
