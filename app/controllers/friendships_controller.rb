class FriendshipsController < ApplicationController
before_filter :setup_friends
  #send a friend request.
  #We'd rather call this "request", but that's not allowed by rails

  def index
    @users = User.players
  end

  def create
    Friendship.request(@user, @friend)
    flash[:notice] = "Friend request sent."
    redirect_to friendships_path
  end

  def accept
    if @user.requested_friends.include?(@friend)
      Friendship.accept(@user, @friend)
      flash[:notice] = "Friendship with #{full_name(@friend)} accepted!"
    else
      flash[:notice] = "No friendship request from #{full_name(@friend)}."
    end
      redirect_to(:back)
  end

  def decline
    if @user.requested_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship with #{full_name(@friend)} declined"
    else
      flash[:notice] = "No friendship request from #{full_name(@friend)}."
    end
      redirect_to(:back)
  end

  def cancel
    if @user.pending_friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship request canceled."
    else
      flash[:notice] = "No request for friendship."
    end
    redirect_to(:back)
  end

  def delete
    if @user.friends.include?(@friend)
      Friendship.breakup(@user, @friend)
      flash[:notice] = "Friendship Terminated."
    else
      flash[:notice] = "Not a friend with #{full_name(@friend)}."
    end
    redirect_to(:back)
  end

  private

  def setup_friends
    @user = User.find_by_id(current_user)
    @friend = User.find_by_id(params[:id])
  end
    
end
