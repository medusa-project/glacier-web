class ArchivesController < ApplicationController

  def index
    @archives = Archive.order('created_at asc').includes(:root)
  end

  def show
    @archive = Archive.includes(:root).find(params[:id])
  end

end