#! /usr/bin/env ruby

# finds and counts words
class WordFinder
  class ArgError < ArgumentError; end
  attr_reader :word, :file

  def initialize(filename, word)
    raise ArgError.new('Cannot find file. Ensure a valid path is used') unless File.exists?(filename)
    raise ArgError.new('Can\'t count words if you don\'t give me one') if word.nil?
    @file = filename
    @word = word
  end

  def count
    puts "Counting occurences of: #{word}"
    puts "Within the provided file: #{file}"
    total = File.foreach(file).sum { |line| line.scan(word_regex).count }
    puts "Total = #{total}"
  end

  private

  def word_regex
    /\b#{word}\b/i
  end
end

# run script
finder = WordFinder.new(ARGV[0], ARGV[1])
finder.count
