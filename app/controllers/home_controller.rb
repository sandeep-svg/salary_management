class HomeController < ApplicationController
  def index
    render file: Rails.root.join('public', 'assets', 'index.html')
  end
end
