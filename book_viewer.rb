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
  erb :search
end

not_found do
  redirect '/'
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").map { |para| "<p>#{para}</p>" }.join
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

    return results if !query || query.empty?

    each_chapter do |name, number, contents|
      results << { number: number, name: name } if contents.include?(query)
    end

    results
  end
end
