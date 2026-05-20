# == Schema Information
#
# Table name: workouts
#
#  id               :bigint           not null, primary key
#  calories         :integer
#  distance_km      :float
#  duration_minutes :integer
#  heart_rate_avg   :integer
#  heart_rate_max   :integer
#  notes            :text
#  raw_data         :text
#  source           :string
#  title            :string
#  workout_date     :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  category_id      :integer
#  user_id          :integer
#
class Workout < ApplicationRecord
end
