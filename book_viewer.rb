require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @toc = File.readlines('data/toc.txt', chomp: true)
  erb :chapter
end

get "/chapters/1" do
  @title = "Chapter 1"
  @toc = File.readlines('data/toc.txt', chomp: true)
  @chapter_contents = File.read("data/chp1.txt")

  erb :chapter
end
