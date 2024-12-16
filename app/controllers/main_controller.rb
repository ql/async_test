class MainController < ApplicationController
  def ordinary_load
    @page = Page.last!
    1000000.times { 1 + 1 }
    render :ordinary_load
  end
end
