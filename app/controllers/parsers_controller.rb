class ParsersController < ResourceController::Base

  def index
    @parsers_by_namespace = Parser.code_by_namespace
  end

end
