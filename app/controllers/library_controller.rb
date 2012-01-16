class LibraryController < ApplicationController
  def index
    @books = Book.all
    #library = Library.new
    #books = library.fetch_amazon_books       
  end
  
  def search  
    library = Library.new
    @books = library.fetch_like(params[:query])
  end
  
  def sort
    @type = params[:type]
    library = Library.new
    @books = library.sort(@type)
  end
end
