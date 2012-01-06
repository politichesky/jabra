class PagesController < ApplicationController
  
  skip_before_filter :authenticate

  def home
  end
end
