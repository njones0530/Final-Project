module ApplicationHelper
  def category_badge_color(category_name)
    colors = {
      "Running" => "primary",
      "Cycling" => "success",
      "Swimming" => "info",
      "Weightlifting" => "danger",
      "Yoga" => "warning",
      "HIIT" => "dark",
      "Other" => "secondary"
    }
    colors[category_name] || "secondary"
  end

  def category_icon(category_name)
    icons = {
      "Running" => "🏃",
      "Cycling" => "🚴",
      "Swimming" => "🏊",
      "Weightlifting" => "🏋️",
      "Yoga" => "🧘",
      "HIIT" => "⚡",
      "Other" => "💪"
    }
    icons[category_name] || "💪"
  end

  def rank_medal(index)
    case index
    when 0 then "🥇"
    when 1 then "🥈"
    when 2 then "🥉"
    else "#{index + 1}."
    end
  end
end

