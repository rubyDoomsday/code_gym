class Prime
  attr_accessor :numbers, :prime_numbers

  def initialize(find = default_stop)
    @total = find
    @prime_numbers = []
  end

  def find_prime
    x = 2
    while @prime_numbers.count < @total
      @prime_numbers << x if prime?(x)
      x += 1
    end
  end

  def show_prime
    @prime_numbers.uniq.to_s
  end

  private

  def prime?(x)
    (2...x).each do |y|
      return false if (x % y).zero?
    end
    true
  end

  def default_stop
    @total ||= 1_000
  end
end

report = Prime.new
report.find_prime
puts report.show_prime
