#! /usr/bin/env ruby

# custome error class
class ArgError < ArgumentError
  def message
    "Usage: count [filename] (options)\n" \
    "Options:\n" \
    "--tags          \tDisplays all availabled hashtags in a file\n" \
    "--lines=[word]  \tDisplays all lines that contain a speicified hashtag\n" \
    "--words=[words] \tList of one ore more hashtags separated by a comma"
  end
end

# custom error class
class FileNotFound < StandardError
  def message
    'Cannot find file. Ensure a valid path is used.'
  end
end

# finds and counts words
class WordFinder
  attr_accessor :words, :file

  def initialize(filename, words = nil)
    raise ArgError unless filename
    raise FileNotFound unless File.exist?(filename)
    @file = filename
    @words = words_to_array(words)
  end

  def count
    words.each do |word|
      total, related_tags = scan(word)
      puts '---'
      puts "### You have #{total} days marked #{word} in #{file.split('.')[0]}."
      puts '#### Related tags:'
      columns(related_tags.compact.uniq)
    end
  end

  def tags
    columns(hashtags)
  end

  def lines
    words.each do |word|
      File.foreach(file).each do |line|
        puts line if line.match(regex(word))
      end
    end
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

  def hashtags
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
begin
  flag, words = ARGV[1].nil? ? [nil, nil] : ARGV[1].split('=')
  finder = WordFinder.new(ARGV[0], words)
  case flag
  when '--tags'  then finder.tags
  when /--lines/ then finder.lines
  when /--words/ then finder.count
  else finder.count
  end
rescue ArgError, FileNotFound => e
  puts e.message
end
