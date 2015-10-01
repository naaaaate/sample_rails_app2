module SessionsHelper
# logs in the given user
  def log_in(user)
    # session is a method that creates a temporary cookie on the page..
    # we are creating a key called user_id for the hash and setting value to user.id
    # session method will encrypt the user.id cookie and put on browser
    session[:user_id] = user.id
  end

  # remember user in a persistent session
  def remember(user)
    # make a call to user.remember in our session controller remember method
    user.remember

    # now place the 2 cookies on the browser:
    # step 1:
    # cookies[:user_id] = { value: user.id, expires: 20.years.from_now.utc } -- same as:
    # cookies.permanent[:user_id] = user.id -- but this leaves user.id unencrypted..
      # session will encrypt user.id, but cookies will not so we need to call signed ..
    cookies.permanent.signed[:user_id] = user.id

    # step 2:
    # here we set random string(user.remember_token) to our cookies remember token..
    cookies.permanent[:remember_token] = user.remember_token

    # now lets modify current user to pull out permanent cookie if the user is NOT logged in..
  end


  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end



# returns current logged in user (if any)
  def current_user
    # so if current user is nil, define it, else return the current user..
      # instance var are nil if they have not been defined.
      # memoization: remembering the value so that u dont have to keep recalculating
    # if @current_user.nil? --instead of saying this, we can use || operator..

      # @current_user = @current_user || User.find_by(id: session[:user_id])
        # instead of saying this ^^ .. we can say:
      # @current_user ||= User.find_by(id: session[:user_id])
        # now if user closes the browser, then ^^ this session[:user_id] goes away.. and the current user will be nil.
        # so lets modify this to pull out permanent user cookie if user is not logged in.

        #if this is nil, then user closed browser..
        if (user_id = session[:user_id])  #this is assignment.
          # so we set current user to the user logged in the current session
          @current_user ||= User.find_by(id: user_id)

          # but if user closes browser, we need to look at cookies when browser is opened again and find the userid and see if he is in the database, if they are in database, see if the remember token in cookies matches with the hash digest password in database.. using the authenticated? method..

          # lets also test a user that visits site after closing the browser..

        elsif(user_id = cookies.signed[:user_id]) #if true, then theres a persistent session and we can pull out that user..
          # this is where if user closes browser..

          # raise # will raise exception in this branch.. which shows this part of code is not being tested.

          user = User.find_by(id: user_id)
          if user && user.authenticated?(cookies[:remember_token])
            log_in user
            @current_user = user
          end
        end


      # side note: User.find_by(session[:user_id]) will return an error if the ID doesnt exist so its better to use User.find_by(id: session[:user_id])
      # wuts this does: session[:user_id] -- this will grab the info from the browser in the cookie, decrypts it, and pulls out the user id.
        # so this hits the db everytime..  User.find_by(id: session[:user_id])
          # but the usual convention in rails is to not hit the DB.. which is why we use the instance variable: @current_user

    # we can get rid of the else, bc we are using the ||= operator up above..
    # else
    #   @current_user
    # end
  end

  # returns true if user is logged in.. false otherwise..
  def logged_in?
    # if current user is nil, then he's not logged in..
    # but if current user is not nil.. then he is logged in..
      # and if he is logged in, this will return true.
    !current_user.nil?
      # remember: !false = true .. says current_user nil? false.. so return not false which is a true.. saying current user is logged in.
  end

# forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)

  end



  def log_out
    forget(current_user)
    session.delete(:user_id)
    # can also do this.. session[:user_id] = nil  instead of session.delete(:user_id)

    # if we called current_user before destroy action and didnt redirect immediately, then could cause an error bc there would be an @current_user lying around.. so bc its security related its a good idea to set this to nil.
    @current_user = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

end
