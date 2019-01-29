class ApplicationController < ActionController::Base
  include ActionView::Helpers::JavaScriptHelper
  protect_from_forgery with: :exception

  before_action :authenticate_user!
end
