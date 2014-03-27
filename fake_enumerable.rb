module FakeEnumerable
  def map
    if block_given?
      new_array = []
      each do |e|
        new_array << yield(e)
      end
      new_array
    else
      FakeEnumerator.new(self, :map)
    end
  end

  def select
    new_array = []
      each do |e|
        if yield(e)
          new_array << e
        end
      end
    new_array
  end

  def sort_by
    new_array = []
    storage_array = []
    #collect
    each do |e|
      storage_array << [yield(e), e]
    end
    #sort
    storage_array.sort!
    #collect
    storage_array.each do |toss, result|
      new_array << result
    end
    new_array
  end

  def reduce(parameters = nil)
    
    # different options for ways parameters used: 
    # symbol, initial & symbol, initial & block, and block.

    case parameters
  
    when Symbol #turn it into a block and send it back.
      return reduce { |operation, element| operation.send(parameters, element) }
    when nil #no specified initial incrementer so we'll take the first value
      total = nil
    else #This is the initial value.
      total = parameters
    end

    # Actual Work Being Done
    each do |x|
      if total.nil?
        total = x
      else
        total = yield(total, x)
      end
    end

    total
  end
end