desc "Create sample data for development"
task sample_data: :environment do
  puts "Clearing existing data..."
  Friendship.destroy_all
  Workout.destroy_all
  Category.destroy_all
  User.destroy_all

  puts "Creating categories..."
  categories = {
    "Running" => { icon: "🏃", color: "#0d6efd" },
    "Cycling" => { icon: "🚴", color: "#198754" },
    "Swimming" => { icon: "🏊", color: "#0dcaf0" },
    "Weightlifting" => { icon: "🏋️", color: "#dc3545" },
    "Yoga" => { icon: "🧘", color: "#ffc107" },
    "HIIT" => { icon: "⚡", color: "#212529" },
    "Other" => { icon: "💪", color: "#6c757d" }
  }

  category_records = {}
  categories.each do |name, attrs|
    category_records[name] = Category.create!(name: name, icon: attrs[:icon], color: attrs[:color])
  end

  puts "Creating users..."
  alice = User.create!(
    email: "alice@example.com",
    password: "password123",
    username: "alice",
    bio: "Marathon runner & yoga enthusiast"
  )

  bob = User.create!(
    email: "bob@example.com",
    password: "password123",
    username: "bob",
    bio: "Gym rat & cyclist"
  )

  carol = User.create!(
    email: "carol@example.com",
    password: "password123",
    username: "carol",
    bio: "Swimmer & HIIT lover"
  )

  puts "Creating workouts for Alice..."
  alice_workouts = [
    { title: "Morning Run", category: "Running", duration: 35, distance: 5.5, hr_avg: 148, hr_max: 175, calories: 380, days_ago: 1 },
    { title: "Long Run", category: "Running", duration: 72, distance: 12.0, hr_avg: 152, hr_max: 178, calories: 780, days_ago: 3 },
    { title: "Interval Sprints", category: "Running", duration: 28, distance: 4.0, hr_avg: 165, hr_max: 190, calories: 350, days_ago: 5 },
    { title: "Vinyasa Flow", category: "Yoga", duration: 60, distance: 0, hr_avg: 95, hr_max: 110, calories: 180, days_ago: 2 },
    { title: "Power Yoga", category: "Yoga", duration: 45, distance: 0, hr_avg: 105, hr_max: 125, calories: 200, days_ago: 6 },
    { title: "Bench Press & Rows", category: "Weightlifting", duration: 50, distance: 0, hr_avg: 115, hr_max: 140, calories: 300, days_ago: 4 },
    { title: "Easy Recovery Run", category: "Running", duration: 25, distance: 3.8, hr_avg: 135, hr_max: 150, calories: 250, days_ago: 7 },
    { title: "Tempo Run", category: "Running", duration: 40, distance: 7.0, hr_avg: 160, hr_max: 180, calories: 450, days_ago: 10 },
    { title: "Pool Laps", category: "Swimming", duration: 40, distance: 1.5, hr_avg: 138, hr_max: 160, calories: 350, days_ago: 8 },
    { title: "Trail Run", category: "Running", duration: 55, distance: 8.0, hr_avg: 155, hr_max: 182, calories: 550, days_ago: 14 },
    { title: "Leg Day", category: "Weightlifting", duration: 55, distance: 0, hr_avg: 120, hr_max: 145, calories: 320, days_ago: 12 },
    { title: "Sunrise Yoga", category: "Yoga", duration: 30, distance: 0, hr_avg: 90, hr_max: 105, calories: 120, days_ago: 15 },
  ]

  alice_workouts.each do |w|
    Workout.create!(
      user: alice,
      category: category_records[w[:category]],
      title: w[:title],
      workout_date: Date.today - w[:days_ago],
      duration_minutes: w[:duration],
      distance_km: w[:distance],
      heart_rate_avg: w[:hr_avg],
      heart_rate_max: w[:hr_max],
      calories: w[:calories],
      source: "manual"
    )
  end

  puts "Creating workouts for Bob..."
  bob_workouts = [
    { title: "Chest & Triceps", category: "Weightlifting", duration: 60, distance: 0, hr_avg: 118, hr_max: 142, calories: 350, days_ago: 1 },
    { title: "Back & Biceps", category: "Weightlifting", duration: 55, distance: 0, hr_avg: 115, hr_max: 138, calories: 330, days_ago: 2 },
    { title: "Road Ride", category: "Cycling", duration: 90, distance: 32.0, hr_avg: 142, hr_max: 168, calories: 650, days_ago: 3 },
    { title: "Shoulder Press Day", category: "Weightlifting", duration: 50, distance: 0, hr_avg: 112, hr_max: 135, calories: 300, days_ago: 4 },
    { title: "Hill Climb Ride", category: "Cycling", duration: 75, distance: 25.0, hr_avg: 155, hr_max: 180, calories: 580, days_ago: 6 },
    { title: "Leg Day Squats", category: "Weightlifting", duration: 65, distance: 0, hr_avg: 125, hr_max: 150, calories: 380, days_ago: 7 },
    { title: "Easy Spin", category: "Cycling", duration: 45, distance: 18.0, hr_avg: 128, hr_max: 145, calories: 320, days_ago: 9 },
    { title: "Deadlift Session", category: "Weightlifting", duration: 55, distance: 0, hr_avg: 120, hr_max: 148, calories: 340, days_ago: 10 },
    { title: "Sprint Intervals on Bike", category: "Cycling", duration: 40, distance: 15.0, hr_avg: 162, hr_max: 188, calories: 420, days_ago: 12 },
    { title: "Morning Jog", category: "Running", duration: 30, distance: 4.5, hr_avg: 140, hr_max: 160, calories: 300, days_ago: 14 },
  ]

  bob_workouts.each do |w|
    Workout.create!(
      user: bob,
      category: category_records[w[:category]],
      title: w[:title],
      workout_date: Date.today - w[:days_ago],
      duration_minutes: w[:duration],
      distance_km: w[:distance],
      heart_rate_avg: w[:hr_avg],
      heart_rate_max: w[:hr_max],
      calories: w[:calories],
      source: "manual"
    )
  end

  puts "Creating workouts for Carol..."
  carol_workouts = [
    { title: "Freestyle Laps", category: "Swimming", duration: 45, distance: 2.0, hr_avg: 140, hr_max: 165, calories: 400, days_ago: 1 },
    { title: "HIIT Circuit", category: "HIIT", duration: 30, distance: 0, hr_avg: 168, hr_max: 192, calories: 380, days_ago: 2 },
    { title: "Backstroke Practice", category: "Swimming", duration: 40, distance: 1.8, hr_avg: 135, hr_max: 158, calories: 350, days_ago: 3 },
    { title: "Tabata Blast", category: "HIIT", duration: 25, distance: 0, hr_avg: 172, hr_max: 195, calories: 340, days_ago: 5 },
    { title: "Open Water Swim", category: "Swimming", duration: 55, distance: 2.5, hr_avg: 145, hr_max: 170, calories: 480, days_ago: 6 },
    { title: "CrossFit WOD", category: "HIIT", duration: 35, distance: 0, hr_avg: 165, hr_max: 188, calories: 400, days_ago: 7 },
    { title: "Medley Drill", category: "Swimming", duration: 50, distance: 2.2, hr_avg: 142, hr_max: 168, calories: 420, days_ago: 9 },
    { title: "Bootcamp", category: "HIIT", duration: 45, distance: 0, hr_avg: 160, hr_max: 185, calories: 450, days_ago: 10 },
    { title: "Evening Swim", category: "Swimming", duration: 35, distance: 1.5, hr_avg: 132, hr_max: 155, calories: 300, days_ago: 12 },
    { title: "Kettlebell HIIT", category: "HIIT", duration: 30, distance: 0, hr_avg: 170, hr_max: 190, calories: 360, days_ago: 13 },
    { title: "Morning Run", category: "Running", duration: 28, distance: 4.0, hr_avg: 145, hr_max: 168, calories: 290, days_ago: 15 },
  ]

  carol_workouts.each do |w|
    Workout.create!(
      user: carol,
      category: category_records[w[:category]],
      title: w[:title],
      workout_date: Date.today - w[:days_ago],
      duration_minutes: w[:duration],
      distance_km: w[:distance],
      heart_rate_avg: w[:hr_avg],
      heart_rate_max: w[:hr_max],
      calories: w[:calories],
      source: "manual"
    )
  end

  puts "Creating friendships..."
  # Alice follows Bob and Carol
  Friendship.create!(follower: alice, followed: bob)
  Friendship.create!(follower: alice, followed: carol)
  # Bob follows Alice
  Friendship.create!(follower: bob, followed: alice)
  # Carol follows Alice and Bob
  Friendship.create!(follower: carol, followed: alice)
  Friendship.create!(follower: carol, followed: bob)

  puts ""
  puts "✅ Sample data created!"
  puts "   #{User.count} users"
  puts "   #{Category.count} categories"
  puts "   #{Workout.count} workouts"
  puts "   #{Friendship.count} friendships"
  puts ""
  puts "Sign in as:"
  puts "   alice@example.com / password123"
  puts "   bob@example.com   / password123"
  puts "   carol@example.com / password123"
end

