class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "fluid"

  before_filter :authenticate_user!

  rescue_from ChefClient::Exceptions::ConfigurationError, SocketError, :with => :chef_configuration_error

  def chef_configuration_error
    render :file => File.join(Rails.root, "public", "chef_configuration_error"), :layout => false, :status => "404"
  end

  def authenticate_owner!
    params.has_key?('user_id') ? id = params['user_id'] : id = params['id']
    if user_signed_in? && current_user.id.to_s == id
      return true
    end
    redirect_to user_path(current_user), :notice => "You can only edit your own profile."
    return false
  end
end
