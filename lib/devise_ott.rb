require 'devise'
require 'warden'
require_relative 'devise_ott/version'
require_relative 'devise_ott/tokens'
require_relative 'devise_ott/models'
require_relative 'devise_ott/strategies'

module Devise
  # Ott redis host
  # defaults to localhost
  mattr_accessor :ott_redis_host
  @@ott_redis_host = 'localhost'
end

module DeviseOtt
end

Warden::Strategies.add(:ott_authentication, DeviseOtt::Strategies::OttAuthentication)
Devise.add_module :ott_authentication, :strategy => true, :model => 'devise_ott/models/ott_authentication'
Warden::Manager.after_authentication do |user,warden,opts|
	if warden.winning_strategy.is_a?(DeviseOtt::Strategies::OttAuthentication)
		warden.session[:ott_authenticated] = true
		warden.session[:ott_granted_to_email] = warden.winning_strategy.granted_to_email
	end
end
