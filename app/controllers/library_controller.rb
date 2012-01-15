class LibraryController < ApplicationController
  def index
    @books = Book.all
    #@library = Library.new
    #@books = @library.fetch_amazon_books       
  end

  def search
    @query = params[:query]
    @books = Book.find(:all, :conditions => ["title LIKE ? or author LIKE ? ", "%#{@query}%", "%#{@query}%"])
  end
end
