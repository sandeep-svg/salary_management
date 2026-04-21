class HomeController < ApplicationController
  def index
    file_path = Rails.root.join('public/assets/index.html')
    content = File.read(file_path)
    render html: content.html_safe
  end
end
