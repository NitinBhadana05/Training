class NotesController < ApplicationController
  before_action :filter_important_notes, only: [:index]

  def index
  end

  def show
    @note = Note.find(params[:id])
  end

  def new
    @note = Note.new
  end

  def create
    @note = Note.new(note_params)

    if @note.save
      redirect_to @note
    else
      render :new
    end
  end

  private

  def filter_important_notes
    @notes = Note.where(important: true)
  end

  def note_params
    params.require(:note).permit(:title, :content, :important)
  end
end