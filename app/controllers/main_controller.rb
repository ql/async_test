class MainController < ApplicationController
  def ordinary_load
    @page = Page.last!
    render :ordinary_load
  end
end
