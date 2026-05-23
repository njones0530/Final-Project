require "csv"

class WorkoutParser
  def initialize(file, user)
    @file = file
    @user = user
  end

  def parse_and_create
    results = { created: 0, errors: [] }

    begin
      csv_content = @file.read
      csv = CSV.parse(csv_content, headers: true, header_converters: :symbol)

      csv.each_with_index do |row, index|
        workout = build_workout(row)

        if workout.save
          # AI categorize each workout
          categorizer = WorkoutCategorizer.new(workout)
          workout.update(category: categorizer.categorize)
          results[:created] += 1
        else
          results[:errors] << "Row #{index + 2}: #{workout.errors.full_messages.join(', ')}"
        end
      end
    rescue CSV::MalformedCSVError => e
      results[:errors] << "Invalid CSV file: #{e.message}"
    rescue StandardError => e
      results[:errors] << "Error processing file: #{e.message}"
    end

    results
  end

  private

  def build_workout(row)
    workout = Workout.new
    workout.user = @user
    workout.source = "csv_upload"

    # Map CSV columns to workout attributes (flexible column names)
    workout.title = extract_value(row, [:activity_name, :title, :name, :activity, :workout_name, :type]) || "Untitled Workout"
    workout.workout_date = parse_date(extract_value(row, [:date, :workout_date, :start_date, :activity_date])) || Date.today
    workout.duration_minutes = extract_numeric(row, [:duration_minutes, :duration, :elapsed_time, :time_minutes, :moving_time])
    workout.distance_km = extract_distance(row)
    workout.heart_rate_avg = extract_numeric(row, [:avg_heart_rate, :heart_rate_avg, :average_heart_rate, :avg_hr])
    workout.heart_rate_max = extract_numeric(row, [:max_heart_rate, :heart_rate_max, :maximum_heart_rate, :max_hr])
    workout.calories = extract_numeric(row, [:calories, :calories_burned, :active_calories, :total_calories])
    workout.notes = extract_value(row, [:notes, :description, :comments])
    workout.raw_data = row.to_h.to_json

    workout
  end

  def extract_value(row, possible_keys)
    possible_keys.each do |key|
      value = row[key]
      return value.strip if value.present?
    end
    nil
  end

  def extract_numeric(row, possible_keys)
    value = extract_value(row, possible_keys)
    return nil if value.blank?

    # Handle time formats like "1:30:00" for duration
    if value.include?(":")
      parts = value.split(":").map(&:to_i)
      if parts.length == 3
        return parts[0] * 60 + parts[1] # hours:min:sec -> minutes
      elsif parts.length == 2
        return parts[0] # min:sec -> minutes
      end
    end

    value.to_f.round
  end

  def extract_distance(row)
    km_value = extract_value(row, [:distance_km, :distance_kilometers])
    return km_value.to_f if km_value.present?

    # Convert miles to km if that's what we have
    mile_value = extract_value(row, [:distance_miles, :distance_mi, :distance])
    return mile_value.to_f * 1.60934 if mile_value.present?

    # Convert meters to km
    meter_value = extract_value(row, [:distance_m, :distance_meters])
    return meter_value.to_f / 1000.0 if meter_value.present?

    nil
  end

  def parse_date(value)
    return nil if value.blank?
    Date.parse(value)
  rescue ArgumentError
    nil
  end
end

