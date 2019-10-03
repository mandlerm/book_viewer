require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @contents = File.readlines('data/toc.txt', chomp: true)
end

helpers do
  def in_paragraphs(chapter)
    chapter.split("\n\n").map { |line| "<p>#{line}</p>" }.join
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

not_found do
  redirect "/"
end
