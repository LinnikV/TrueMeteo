class ApplicationController < ActionController::Base
  include ErrorCathing
  include Pagy::Backend
end
