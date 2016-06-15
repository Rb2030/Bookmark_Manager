ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require_relative 'data_mapper_setup'

class BookmarkManager < Sinatra::Base

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  get '/links/new' do
    erb :'links/new'
  end

  post '/links' do
    link = Link.new(url: params[:url], title: params[:title])
    tag  = Tag.first_or_create(name: params[:tag])
    link.tags << tag
    link.save
    redirect to('/links')
  end

  get '/tags/bubbles' do
    @links = Link.select { |link| link.tags.map(&:name).include?('bubbles') }
    erb :'links/index'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links= tag ? tag.links : []
    erb :'links/index'
  end

  run! if app_file == $0

end
