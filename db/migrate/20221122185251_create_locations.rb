class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.time :day_start
      t.time :day_end
      t.time :lunch_start
      t.time :lunch_end

      t.timestamps
    end
  end
end
