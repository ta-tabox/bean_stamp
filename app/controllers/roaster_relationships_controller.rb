class RoasterRelationshipsController < ApplicationController
  before_action :authenticate_user!
  def create
    @roaster = Roaster.find(params[:roaster_id])
    current_user.following_roasters << @roaster
    respond_to do |format|
      format.html { redirect_to @roaster }
      format.js
    end
  end

  def destroy
    @roaster = RoasterRelationship.find(params[:id]).roaster
    current_user.following_roasters.delete(@roaster)
    respond_to do |format|
      format.html { redirect_to @roaster }
      format.js
    end
  end
end
