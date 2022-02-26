# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

get '/' do
  @title = 'The Adventures of Sherlock Holmes!'
  @contents = File.readlines 'data/toc.txt'
  erb :home
end

get '/chapters/1' do
  @title = 'Chapter 1'
  @contents = File.readlines 'data/toc.txt'
  @paragraphs = File.read('data/chp1.txt').split("\n\n")

  erb :chapter
end
