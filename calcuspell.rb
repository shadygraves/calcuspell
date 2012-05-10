#!/usr/bin/env ruby -wKU

require "rubygems"
require "raspell"
require "paint"

MAX_WORD_SIZE = 8

speller = Aspell.new("en_US")
speller.suggestion_mode = Aspell::NORMAL
speller.set_option("ignore-case", "true")

alphabet = [ 'b', 'e', 'g', 'h', 'i', 'l', 'j', 'o', 's', 'z']

words_array = []
(10..((10*(10**(MAX_WORD_SIZE-1)))-1)).each do |i|
	tmp_word = ""
	string_version = i.to_s
	string_version.each_char do |c|
		tmp_word += alphabet[c.to_i]
	end
	
	color = :green
	if speller.check(tmp_word)
		words_array << tmp_word
		puts "permutation #{i}\t| word #{words_array.length}\t | " + Paint["#{tmp_word}", :green]
	end

	
end

puts Paint["\n\n#{words_array.length} possible words found.", :blue, :bright]
puts "\n"
words_array.each { |w| print Paint[w, :green] + "#{w != words_array.last ? ", " : ""}"}
puts "\n"