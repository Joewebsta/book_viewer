# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

before do
  @contents = File.readlines('data/toc.txt')
end

get '/' do
  @title = 'The Adventures of Sherlock Holmes!'
  erb :home
end

get '/chapters/:number' do
  number = params[:number].to_i
  chapter_name = @contents[number - 1]
  @title = "Chapter #{number} - #{chapter_name}"

  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map { |para| "<p>#{para}</p>" }.join
  end
end
