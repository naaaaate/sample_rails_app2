class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Log the user in and redirect to the user's show page.
      log_in user
        # creating cookie here to store in browser inside of session[:user_id]

      # create remember_me if statement to remember or forget user if checkbox checked:
     # if params[:session}[:remember_me] == '1'
     #  remember user
     # else
     #  forget user
     # end
     # this can be combined to ternary operator:
     params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      # NOTE: remember(user) and forget(user) are session helper methods.

     redirect_back_or user

     # redirect_to user
        # now we redirect to the user's profile page which is: /user/:id of the user


    else
      # flash now will flash for the render and thats it.. remember we are not re-directing so w o the .now, it would throw an error..
      flash.now[:danger] = 'Invalid email/password combination'
      # Create an error message.
      render 'new'
    end
  end

  # this logs user out.. by calling logout and redirecting to home page.
  def destroy
    log_out if logged_in? #FIXES SUBTLE ISSUE W LOGOUT
    redirect_to root_url
      # normally do root_path but w redirect we want full url

  end
end