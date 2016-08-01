class RootsController < ApplicationController

  def index
    @roots = Root.order('created_at asc')
  end

end