class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
   @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])

  end

  def new
    @user = User.new
  end

  def create
    #used to be: User.new(params[:user]) ..but now uses strong params so ppl cant insert any code in a form and the create method wont just accept an entire hash of attributes..which could allow someone to sign up as an admin
    @user = User.new(user_params)
    if @user.save
      # login the user..
      log_in @user
      # Handle a successful save.
      # use flash hash w success key to display a successful save:
         flash[:success] = "Welcome to the Sample App!"

          # u can iterate thru a flash hash in console like so..
            # $ rails console
            # >> flash = { success: "It worked!", danger: "It failed." }
            # => {:success=>"It worked!", danger: "It failed."}
            # >> flash.each do |key, value|
            # ?>   puts "#{key}"
            # ?>   puts "#{value}"
            # >> end
            # success
            # It worked!
            # danger
            # It failed.



      # use redirect_to @user bc it specifies the user id we just created
         redirect_to @user
        # where we could have used the equivalent
        #     redirect_to user_url(@user)
        # This is because Rails automatically infers from redirect_to @user that we want to redirect to user_url(@user).

    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)  #returns true if update succeeds..and calls strong params.
      # handle succesful update
      flash[:success] = "Profile Updated"
      redirect_to @user

    else
      render 'edit'
    end
    # NOTE: create integration test to sim user editing form.
      # rails g integration_test users_edit
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end





  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

     # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
