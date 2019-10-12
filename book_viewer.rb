require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"
require 'pry'

before do
  @contents = File.readlines('data/toc.txt', chomp: true)
end

helpers do
  def in_paragraphs(chapter)
    chapter.split("\n\n").map.with_index { |line, index| "<p id=paragraph#{index} >#{line}</p>" }.join
  end
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  number = params[:number].to_i
  chapter_name = @contents[number - 1]

  redirect "/" unless (1..@contents.size).cover? number

  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/show/:name" do
  params[:name]
end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end

not_found do
  redirect "/"
end

# helper methods for 'search' route

def each_chapter
  @contents.each_with_index do |name, index|
    number = index + 1
    contents = File.read("data/chp#{number}.txt")
    yield number, name, contents
  end
end

def chapters_matching(query)
  results = []

  return results if !query || query.empty?

  each_chapter do |number, name, contents|
    matches = {}
    contents.split("\n\n").each_with_index do |paragraph, index|
      if paragraph.include?(query)
        str_location = paragraph.index(query)
        formatted_string = paragraph[0..str_location - 1] + "<strong>" + query + "</strong>"  + paragraph[str_location + query.length..-1]


        matches[index] = formatted_string
      end
    end
    results << {number: number, name: name, paragraphs: matches} if matches.any?
  end
  results
end

# if it includes query
  # => then we need to read line-by-line (or paragraph by paragraph)
  # ==> when we find a match, we returned all of the text in that paragraph.
    # ===> results << [text from the paragraph]
    # link will be 1. to that page, and 2. to that ID
