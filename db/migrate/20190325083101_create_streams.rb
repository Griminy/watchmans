class CreateStreams < ActiveRecord::Migration[5.0]
  def change
    create_table :hooks do |t|
      t.belongs_to :customer
      t.belongs_to :video

      t.timestamps
    end
  end
end
