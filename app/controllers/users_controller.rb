# Implement for all users
# http://www.tonyamoyal.com/2010/09/29/rails-authentication-with-devise-and-cancan-part-2-restful-resources-for-administrators/
class UsersController < ApplicationController
  load_and_authorize_resource
  # load_and_authorize_resource :attachment, :through => :user, :shallow => true
  # load_and_authorize_resource :attachment, :only => :attachments

  def index
    # @users = User.all
  end

  def create
    puts "CREATE HERE - "
    super
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def attachments
    # authorize! :read, @object
    # puts "ATTACHMeNT: #{@attachment}"
    # puts "ATTACHMeNTs: #{@attachments}"
    # puts "USEr: #{@user}"
    @attachments = @user.attachments
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

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      puts "User PARAMS- :#{params.inspect}"
      # "user"=>{"email"=>"test@test.test", "attachment_ids"=>["", "1"]}
      params.require(:user).permit(:email, {:attachment_ids => []})
    end
  # def show
  # end
end
