#! /usr/bin/env ruby

# finds and counts words
class WordFinder
  class ArgError < ArgumentError; end
  attr_reader :words, :file

  def initialize(filename, words = nil)
    raise ArgError.new('Cannot find file. Ensure a valid path is used.') unless File.exists?(filename)
    @file = filename
    @words = words_to_array(words)
  end

  def count
    words.each do |word|
      total, related_tags = scan(word)
      puts "---"
      puts "### You have #{total} days marked #{word} in #{file.split('.')[0]}."
      puts "#### Related tags:"
      columns(related_tags.compact.uniq)
    end
  end

  def all_tags
    columns(tags)
  end

  private

  def scan(word)
    total = 0
    related_tags = []
    File.foreach(file).each do |line|
      total += line.scan(regex(word)).count
      related_tags += parse_tags(line) if line.match(regex(word))
    end
    [total, related_tags]
  end

  def tags
    File.foreach(file).flat_map { |l| parse_tags(l) }.compact.uniq
  end

  def parse_tags(line)
    return if line.strip == ''
    line.split(' ').select { |w| w if w.start_with?('#') }
  end

  def regex(word)
    /\b#{word}\b/i
  end

  def words_to_array(words)
    return [] if words.nil?
    words.split(',')
  end

  def columns(list)
    max_length = list.max_by(&:length).length
    list.sort.each_slice(6).map { |s| s }.each do |r|
      r.each { |c| print "#{equalize(c, max_length)}\t" }
      print "\n"
    end
  end

  def equalize(word, length)
    space = length - word.length
    "#{word}#{' ' * space}"
  end
end

# run script
if ARGV[1] == '--tags'
  finder = WordFinder.new(ARGV[0])
  finder.all_tags
else
  finder = WordFinder.new(ARGV[0], ARGV[1])
  finder.count
end
