#!/usr/bin/env ruby
require 'sinatra'
require 'haml'

require 'dm-core'
require 'dm-migrations'

class Document
  include DataMapper::Resource
  property :read_key, String, :key => true
  property :write_key, String
  property :body, Text

  def title
    (body || "").split("\n").first
  end
end

configure do
  DataMapper.setup(:default, (ENV["DATABASE_URL"] || "sqlite3:///#{Dir.pwd}/development.sqlite3"))
  DataMapper.auto_upgrade!
end

require "sinatra/reloader" if development?


module RandomId
  def self.generate
    (0..15).collect{(rand*16).to_i.to_s(16)}.join
  end
end

get '/' do
  read_key = RandomId.generate
  write_key = RandomId.generate
  redirect "/#{read_key}/#{write_key}"
end

get '/supersecret' do
  Document.all.map do |d|
    [d.read_key, d.write_key, d.title].join "; "
  end.join "<br/>"
end

get '/:read_key' do
  @mode = "read"
  doc = Document.first(:read_key => params[:read_key])
  if doc.nil?
    halt 404, "no that document is not here"
  else
    @body = doc.body
  end
  haml :index
end

get '/:read_key/:write_key' do
  @mode = params[:mode] || "normal"

  doc = Document.first(:read_key => params[:read_key])

  if doc.nil? || doc.write_key == params[:write_key]
    @body = (doc && doc.body) || "Welcome to TypeWriter.tw!"
    haml :index
  else
    halt 403, 'go away!'
  end
end

post '/:read_key/:write_key' do
  doc = Document.first(:read_key => params[:read_key])
  text = request.body.read

  if doc.nil?
    doc = Document.create(read_key: params[:read_key], write_key: params[:write_key], body: text)
  elsif doc.write_key != params[:write_key]
    halt 403, 'go away!'
  else
    doc.update(body: text)
    p "writing"
  end
end



