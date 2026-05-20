class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  # --- Assocations ---
  has_many :workouts, dependent: :destroy

  #Friendships where this user is the follower
  has_many :sent_friendships, class_name: "Friendship", foreign_key: "follower_id", dependent: :destroy
  #Friendships where this user is being followed
  has_many :received_friendships, class_name: "Friendship", foreign_key: "followed_id", dependent: :destroy

  #People this user follows
  has_many :following, through: :sent_friendships, source: :followed
  #People who follow this user
  has_many :followers, through: :received_friendships, source: :follower

  #---Validations---
  validates :username, presence: true, uniqueness: true

  # --- Instance Methods ---

  def follows?(other_user)
    sent_friendships.exists?(followed_id: other_user.id)
  end

  def follow(other_user)
    return false if other_user == self
    return false if follows?(other_user)
    sent_friendships.create(followed_id: other_user.id)
  end

  def unfollow(other_user)
    sent_friendships.where(followed_id: other_user.id).destroy_all
  end

  def feed_users
    User.where(id: following.pluck(:id) + [id])
  end 

  def total_duration
    workouts.sum(:duration_minutes)
  end

  def total_distance
    workouts.sum(:distance_km)
  end

  def total_calories
    workouts.sum(:calories)
  end

  def total_workouts
    workouts.count
  end

  def workouts_this_week
    workouts.where("workout_date >= ?", Date.today.beginning_of_week).count
  end

  def display_name
    username.presence || email.split("@").first
  end
end 
