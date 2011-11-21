get '/' do
  @title = @@conf['title']
  haml :index
end

get '/app' do
  haml :app
end
