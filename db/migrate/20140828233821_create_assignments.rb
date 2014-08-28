class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.references :timeslot, index: true
      t.references :boat, index: true
      t.hstore :meta

      t.timestamps
    end
  end
end
