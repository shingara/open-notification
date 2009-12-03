# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def title_header
    title = "Open-notification"
    title += " : #{@title}" if @title
    title
  end
end
