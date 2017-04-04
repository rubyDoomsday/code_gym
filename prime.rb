# Finds prime numbers
class Prime
  attr_accessor :numbers, :prime_numbers

  # @param total [Integer] the number of primes you want to find
  def initialize(total)
    @total = total || default_stop
    @prime_numbers = []
  end

  # Builds an array of prime numbers
  def find_prime
    x = 2
    while @prime_numbers.count < @total
      @prime_numbers << x if prime?(x)
      x += 1
    end
  end

  # Shows the array of prime numbers as a string
  def show_prime
    @prime_numbers.uniq.to_s
  end

  private

  # Determines if the provided number is prime
  # @param number [Integer] number to check
  def prime?(number)
    (2...number).each do |x|
      return false if (number % x).zero?
    end
    true
  end

  # Defualt stopping point if none provided
  def default_stop
    @total ||= 1_000
  end
end

this_many = ARGV[0].to_i unless ARGV[0].nil?
report = Prime.new(this_many)
report.find_prime
puts report.show_prime
