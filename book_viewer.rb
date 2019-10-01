require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @toc = File.readlines('data/toc.txt', chomp: true)
  erb :chapter
end

get "/chapters/:num" do |num|
  @title = "Chapter #{num}"
  @toc = File.readlines('data/toc.txt', chomp: true)
  @chapter_contents = File.read("data/chp#{num}.txt")

  erb :chapter
end
