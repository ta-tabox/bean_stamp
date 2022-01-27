class RoasterRelationshipsController < ApplicationController
  before_action :user_signed_in_required
  def create
    @roaster = Roaster.find(params[:roaster_id])
    current_user.follow_roaster(@roaster)
    respond_to do |format|
      format.html { redirect_to @roaster }
      format.js
    end
  end

  def destroy
    @roaster = RoasterRelationship.find(params[:id]).roaster
    current_user.unfollow_roaster(@roaster)
    respond_to do |format|
      format.html { redirect_to @roaster }
      format.js
    end
  end
end
