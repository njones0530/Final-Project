class FriendshipsController < ApplicationController
  def index
    matching_friendships = Friendship.all

    @list_of_friendships = matching_friendships.order({ :created_at => :desc })

    render({ :template => "friendship_templates/index" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_friendships = Friendship.where({ :id => the_id })

    @the_friendship = matching_friendships.at(0)

    render({ :template => "friendship_templates/show" })
  end

  def create
    the_friendship = Friendship.new
    the_friendship.follower_id = params.fetch("query_follower_id")
    the_friendship.followed_id = params.fetch("query_followed_id")

    if the_friendship.valid?
      the_friendship.save
      redirect_to("/friendships", { :notice => "Friendship created successfully." })
    else
      redirect_to("/friendships", { :alert => the_friendship.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_friendship = Friendship.where({ :id => the_id }).at(0)

    the_friendship.follower_id = params.fetch("query_follower_id")
    the_friendship.followed_id = params.fetch("query_followed_id")

    if the_friendship.valid?
      the_friendship.save
      redirect_to("/friendships/#{the_friendship.id}", { :notice => "Friendship updated successfully." } )
    else
      redirect_to("/friendships/#{the_friendship.id}", { :alert => the_friendship.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_friendship = Friendship.where({ :id => the_id }).at(0)

    the_friendship.destroy

    redirect_to("/friendships", { :notice => "Friendship deleted successfully." } )
  end
end
