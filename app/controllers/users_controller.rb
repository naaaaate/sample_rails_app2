class UsersController < ApplicationController

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

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
