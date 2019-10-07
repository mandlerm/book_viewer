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

get "/search" do
  @results = {}
  @search_term = params[:query]
    if @search_term
      @contents.each_with_index do |chap, idx|
        chapter = File.read("data/chp#{idx + 1}.txt")
        @results[@contents[idx]] = idx + 1 if chapter.downcase.include?(@search_term.downcase)

      end
    end

  erb :search
end

not_found do
  redirect "/"
end
