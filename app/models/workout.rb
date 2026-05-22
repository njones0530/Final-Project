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
  belongs_to :user
  belongs_to :category, optional: true 

  validates :title, presence: true
  validates :workout_date, presence: true
    validates :duration_minutes, numericality: { greater_than: 0, allow_nil:true } 
    validates :distance_km, numericality: { greater_than_or_equal_to: 0, allow_nil: true}
    validates :heart_rate_avg, numericality: { greater_than: 0, allow_nil: true }
    validates :heart_rate_max, numericality: { greater_than: 0, allow_nil: true }
    validates :calories, numericality: { greater_than: 0, allow_nil: true }

    scope :recent, -> { order(workout_date: :desc) }
    scope :this_week, -> { where("workout_date >= ?", Date.today.beginning_of_week) }
    scope :this_month, -> { where("workout_date >= ?", Date.today.beginning_of_month) }
    scope :by_category, ->(category) { where(category: category) }

    def formatted_duration
      return "-" unless duration_minutes
      hours = duration_minutes / 60 
      mins = duration_minutes % 60
      if hours > 0 
        "#{hours}h #{mins}m"
      else
        "#{mins}m"
      end
    end
    
    def formatted_distance
      return "-" unless distance_km && distance_km > 0
      "#{distance_km.round(1)} km"
    end

    def category_name
      category&.name || "Uncategorized"
    end
  end  
