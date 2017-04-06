# Finds the last occurence
class LinearSearch
  # @param find [Integer] the number you are searching for
  # @param length [Integer] the length of the test array
  def initialize(find, length = nil)
    raise ArgumentError.new 'No search item provided' if find.nil?
    @find = find
    @array = array_with_length(length || default_length)
  end

  def results
    puts "Looking for: #{@find}"
    puts "In the array: #{@array}"
    if position = find_last_occurence
      puts "The last occurence of #{@find} is in position #{position}"
    else
      puts 'The number did not appear in the array'
    end
  end

  private

  def find_last_occurence
    index = nil
    @array.length.times do |i|
      index = i if @array[i].to_s.include?(@find.to_s)
    end
    index
  end

  # @return [Array] an array of random numbers
  def array_with_length(length)
    Array.new(length) { rand(0..99) }
  end

  def default_length
    10
  end
end

find_me = ARGV[0].to_i unless ARGV[0].nil?
length  = ARGV[1].to_i unless ARGV[1].nil?
report  = LinearSearch.new(find_me, length)
report.results
