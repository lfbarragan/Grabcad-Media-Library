class Library < ActiveRecord::Base
  has_many :books
  
  
  def fetch_amazon_books
  require "amazon/ecs"    
    # default options; will be camelized and converted
    # to REST request parameters.
    @acces_key = 'AKIAI3PL4W3ZIWMCCQHA'
    Amazon::Ecs.options = {:aWS_access_key_id => "[AKIAI3PL4W3ZIWMCCQHA]"}
    res = Amazon::Ecs.item_search("ruby",  {:response_group => "Medium", :sort => "salesrank"})

    @books = Array.new  
    res.items.each do |item|
      @book = Book.new
      
    # retrieve string value using XML path
      item.get("asin")
      item.get("itemattributes/title")

      # return Amazon::Element instance
      item_attributes = item.get_element("itemattributes")      
      @book.title = item_attributes.get("title")
      # return first author or a string array of authors
      @book.author = item_attributes.get("author")

      # return an hash of children text values with the element names as the keys
      @book.image_url = item.get_hash("smallimage")
      @books << @book
    end

  end
end
