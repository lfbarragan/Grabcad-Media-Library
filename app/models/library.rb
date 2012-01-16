class Library < ActiveRecord::Base
  has_many :books
  
  def fetch_like(query)
    Book.find(:all, :conditions => ["title LIKE ? or author LIKE ? ", "%#{query}%", "%#{query}%"])
  end
  
  def sort(type)
    books = Book.all
    books = mergesort(books, type)       
    return books
  end
  
  def mergesort(array, type)
    # an array size 1 or less is already sorted
    if array.size <= 1
      return array
    end
    
    # find middle point and spit original array in two
    middle_point = array.size / 2
    
    lArray = []
    for i in (0...middle_point)
      lArray.push(array[i])
    end
    
    rArray = []
    for i in (middle_point... array.size)
      rArray.push(array[i])
    end
    
    #  recursively sort the arrays and merge them
    lArray = mergesort(lArray, type)
    rArray = mergesort(rArray, type)
    return merge(lArray, rArray, type)
  end
  
  def merge(lArray,rArray, type)
    sorted_array = []
    # if there is something in both arrays, move it to the sorted array
    while lArray.size > 0 && rArray.size > 0
      if 'author' == type
        lBook = lArray[0].author
        rBook = rArray[0].author
      else
        lBook = lArray[0].title
        rBook = rArray[0].title        
      end
      
      result = lBook <=> rBook
      if result > 0
        sorted_array  << rArray.shift
      else
        sorted_array << lArray.shift
      end      
    end
    
    # if something remains, then add it to the result
    if lArray.size > 0 
      lArray.each { |e|  sorted_array << e} 
    end
    
    if rArray.size > 0
      rArray.each { |e| sorted_array << e}      
    end
    
    return sorted_array
  end
   
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
