class CreateWorkouts < ActiveRecord::Migration[8.0]
  def change
    create_table :workouts do |t|
      t.string :title
      t.date :workout_date
      t.integer :duration_minutes
      t.float :distance_km
      t.integer :heart_rate_avg
      t.integer :heart_rate_max
      t.integer :calories
      t.string :source
      t.text :raw_data
      t.text :notes
      t.integer :user_id
      t.integer :category_id

      t.timestamps
    end
  end
end
