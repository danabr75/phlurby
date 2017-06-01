class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # protected
  private

  def before_filter(*filters, &block)
    before_action(filters, block)
  end
end
