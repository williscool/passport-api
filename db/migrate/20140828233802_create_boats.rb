class CreateBoats < ActiveRecord::Migration
  def change
    create_table :boats do |t|
      t.string :name
      t.integer :capacity
      t.hstore :meta

      t.timestamps
    end
  end
end
