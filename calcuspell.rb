#!/usr/bin/env ruby -wKU

require "rubygems"
require "raspell"
require "paint"

class Worker
	def find_words(handle_count, offset, thread_id, alphabet)

		words_array = []

		speller = Aspell.new("en_US")             # yeah yeah, globals, bad. I'm just writing this fast to experiment
		speller.suggestion_mode = Aspell::NORMAL
		speller.set_option("ignore-case", "true")

		sp = (handle_count * thread_id) + offset
		ep = ((handle_count * (thread_id+1))+offset) - 1

		puts "#{Paint["----------->", :yellow, :bright]} thread #{Paint[thread_id, '#ffaa00']}, sp: #{sp}, ep: #{ep}\n"
		(sp..ep).each do |i|
			tmp_word = ""
			string_version = i.to_s
			string_version.each_char do |c|
				tmp_word += alphabet[c.to_i]
			end
			
			if speller.check(tmp_word)
				words_array << tmp_word
				puts "thread " + Paint[thread_id, '#ffaa00'] + "\t| permutation #{i}\t| word #{words_array.length}\t | " + Paint["#{tmp_word}", :green] + "\n"
			else
				# puts "thread " + Paint[thread_id, '#ffaa00'] + "\t| permutation #{i}\t| word #{words_array.length}\t | " + Paint["#{tmp_word}", :red] + "\n"
			end
		end
		puts Paint["Thread #{thread_id} exiting!", :red, :bright]
		words_array
	end
end

MAX_WORD_SIZE = 8
THREADS 	  = 4



alphabet = [ 'b', 'e', 'g', 'h', 'i', 'l', 'j', 'o', 's', 'z']

words_array = []
max 	= (10 * ( 10**(MAX_WORD_SIZE - 1) )) - 1
start 	= 10

puts "Max word size: #{MAX_WORD_SIZE}"
puts "Max permutations: #{max}"
puts "Start offset: #{start}"

threads = []

# determine which chunk each thread will take
# we'll just split it up easily for simplicity sake
# in reality this should be weights more twords the larger size words
# oh well

total = max - start
each_thread_handles = total / THREADS

puts "Total permutations: #{total}"
puts "Thread count: #{THREADS}"
puts "Each thread will handle: #{each_thread_handles}"


THREADS.times do |tt|
	puts "Starting thread #{Paint[tt, :red]}...\n"
	threads << Thread.new do
		w = Worker.new
		words_array += w.find_words(each_thread_handles, start, tt, alphabet)
	end
end

threads.each {|t| t.join }  # wait for each thread to end


puts Paint["\n\n#{words_array.length} possible words found.", :blue, :bright]
puts "\n"
words_array.each { |w| print Paint[w, :green] + "#{w != words_array.last ? ", " : ""}"}
puts "\n"




