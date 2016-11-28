class RootsController < ApplicationController

  def index
    @roots = Root.order('created_at asc')
  end

  def archives
    @root = Root.find_by(path: params[:path])
    @archives = @root.archives.order('created_at asc')
  end

  def archives_for_file
    @root = Root.find_by(path: params[:root_path])
    @file = @root.file_infos.find_by(path: params[:file_path])
    @archives = @file.archives.order('created_at asc')
  end

  def create
    path = params[:path]
    render 'create_exists' and return if @root = Root.find_by(path: path)
    render 'create_no_directory' and return unless PathTranslator::RootSet[:storage].exist?(path)
    @root = Root.create(path: path)
  end

end