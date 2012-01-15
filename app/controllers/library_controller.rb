class LibraryController < ApplicationController
  def index
    @books = Book.all       
  end

  def search
    @query = params[:query]
    @books = Book.all
  end
end
