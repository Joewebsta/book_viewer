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

  redirect '/' unless (1..@contents.size).cover? number

  @title = "Chapter #{number}: #{chapter_name}"
  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get '/search' do
  @query = params[:query]
  @results = matching_chapters(@query)
  # require 'pry'; binding.pry
  erb :search
end

not_found do
  redirect '/'
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map.with_index do |para, index|
      "<p id='paragraph#{index}'>#{para}</p>"
    end.join
  end
end

def each_chapter
  @contents.each_with_index do |name, index|
    chap_num = index + 1
    chapter = File.read("data/chp#{chap_num}.txt")
    yield name, chap_num, chapter
  end
end

def matching_chapters(query)
  results = []

  return results unless query

  each_chapter do |name, number, contents|
    matches = {}
    contents.split("\n\n").each_with_index do |paragraph, index|
      matches[index] = paragraph if paragraph.include?(query)
    end
    results << { number: number, name: name, paragraphs: matches } if matches.any?
  end

  results
end
