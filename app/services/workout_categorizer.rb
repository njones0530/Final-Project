class WorkoutCategorizer
  # Use OpenAI via Prepend.me — no personal API key needed!
  # Just set your PREPEND_ME_TOKEN environment variable.
  API_URL = "https://prepend.me/api.openai.com/v1/chat/completions"

  def initialize(workout)
    @workout = workout
  end

  def categorize
    category_names = Category.pluck(:name)

    prompt = build_prompt(category_names)

    begin
      response = HTTParty.post(
        API_URL,
        headers: {
          "Content-Type" => "application/json",
          "Authorization" => "Bearer #{ENV.fetch("PREPEND_ME_TOKEN")}"
        },
        body: {
          model: "gpt-4.1-mini",
          messages: [
            { role: "system", content: "You are a fitness workout categorizer. Respond with ONLY the category name, nothing else." },
            { role: "user", content: prompt }
          ],
          max_tokens: 50,
          temperature: 0
        }.to_json
      )

      parsed = JSON.parse(response.body)
      ai_answer = parsed.dig("choices", 0, "message", "content")&.strip

      # Find the matching category
      match = Category.where("LOWER(name) = ?", ai_answer.downcase).first

      if match
        match
      else
        # Try partial match
        Category.all.find { |c| ai_answer.downcase.include?(c.name.downcase) } || Category.find_by(name: "Other")
      end

    rescue StandardError => e
      Rails.logger.error("AI categorization failed: #{e.message}")
      fallback_categorize
    end
  end

  private

  def build_prompt(category_names)
    parts = []
    parts << "Categorize this workout into exactly one of these categories: #{category_names.join(', ')}."
    parts << ""
    parts << "Workout details:"
    parts << "- Title/Activity: #{@workout.title}"
    parts << "- Duration: #{@workout.duration_minutes} minutes" if @workout.duration_minutes.present?
    parts << "- Distance: #{@workout.distance_km} km" if @workout.distance_km.present? && @workout.distance_km > 0
    parts << "- Average Heart Rate: #{@workout.heart_rate_avg} bpm" if @workout.heart_rate_avg.present?
    parts << "- Max Heart Rate: #{@workout.heart_rate_max} bpm" if @workout.heart_rate_max.present?
    parts << "- Calories: #{@workout.calories}" if @workout.calories.present?
    parts << "- Notes: #{@workout.notes}" if @workout.notes.present?
    parts << ""
    parts << "Use the heart rate data, duration, distance, and activity name to determine the best category."
    parts << "For example: high heart rate + distance likely = Running or Cycling. No distance + moderate heart rate = Weightlifting or Yoga."
    parts << ""
    parts << "Respond with ONLY the category name, nothing else."

    parts.join("\n")
  end

  def fallback_categorize
    title = @workout.title.to_s.downcase

    category_name = if title.match?(/run|jog|sprint|marathon|5k|10k/)
      "Running"
    elsif title.match?(/cycl|bike|ride|spin/)
      "Cycling"
    elsif title.match?(/swim|pool|lap/)
      "Swimming"
    elsif title.match?(/weight|lift|bench|squat|deadlift|press|curl|strength/)
      "Weightlifting"
    elsif title.match?(/yoga|stretch|flex|pilates/)
      "Yoga"
    elsif title.match?(/hiit|interval|circuit|crossfit|tabata|bootcamp/)
      "HIIT"
    else
      "Other"
    end

    Category.find_by(name: category_name) || Category.first
  end
end

