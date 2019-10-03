require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  @contents = File.readlines('data/toc.txt', chomp: true)
  erb :home
end

get "/chapters/:num" do |num|
  @contents = File.readlines('data/toc.txt', chomp: true)
  @chapter = File.read("data/chp#{num}.txt")
  chapter_name = @contents[num.to_i - 1]
  @title = "Chapter #{num}: #{chapter_name}"

  erb :chapter
end

get "/show/:name" do
  params[:name]
end
