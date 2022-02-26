# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'

get '/' do
  @title = 'The Adventures of Sherlock Holmes!'

  @contents = File.readlines 'data/toc.txt'
  # @chapters = contents.split("\n")
  erb :home
end
