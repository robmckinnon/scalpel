require 'syntax/convertors/html'

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def highlight_syntax(code)
    Syntax::Convertors::HTML.for_syntax("ruby").convert(code)
  end
end
