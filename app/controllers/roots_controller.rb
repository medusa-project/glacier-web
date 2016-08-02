class RootsController < ApplicationController

  def index
    @roots = Root.order('created_at asc')
  end

  def archives
    @root = Root.find_by(path: params[:path])
    @archives = @root.archives.order('created_at asc')
  end

  def create
    path = params[:path]
    if @root = Root.find_by(path: path)
      render 'create_exists'
    else

    end
  end

end