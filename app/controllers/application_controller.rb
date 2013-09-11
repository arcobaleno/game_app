class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  include UsersHelper
  include PoolsHelper
  include FriendshipsHelper

  #Return true if a parameter corresponding to the given symbol was posted.
  def param_posted?(sym)
  	request.post? and params[sym]
  end

end
