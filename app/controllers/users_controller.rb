# Implement for all users
# http://www.tonyamoyal.com/2010/09/29/rails-authentication-with-devise-and-cancan-part-2-restful-resources-for-administrators/
class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    # @users = User.all
  end


  def disable
    @user.update_column(:disabled, true)

    # head :ok
    redirect_back(fallback_location: root_path)
  end

  def renable
    @user.update_column(:disabled, false)

    # head :ok
    redirect_back(fallback_location: root_path)
  end
  # def show
  # end
end
