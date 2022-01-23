class RoasterRelationshipsController < ApplicationController
  before_action :user_signed_in_required
  def create
    roaster = Roaster.find(params[:roaster_id])
    current_user.follow_roaster(roaster)
    redirect_to roaster
  end

  def destroy
    roaster = RoasterRelationship.find(params[:id]).roaster
    current_user.unfollow_roaster(roaster)
    redirect_to roaster
  end
end
