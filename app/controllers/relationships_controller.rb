class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find_by id: params[:followed_id]
    action_follow_unfollow @user, "follow"
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    action_follow_unfollow @user, "unfollow"
  end

  private

  def action_follow_unfollow user, action
    if user
      current_user.send action, user
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    else
      flash[:warning] = t ".user_not_found"
      redirect_to root_url
    end
  end
end
