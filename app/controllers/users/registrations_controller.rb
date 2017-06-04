class RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, :only => :create

  # def update
  #   puts "GOT HERE13231"
  #   super
  # end
end