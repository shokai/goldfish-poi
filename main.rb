get '/' do
  @title = @@conf['title']
  haml :index
end

post '/tag/:hex_id' do
  @id = params[:hex_id].downcase
  unless @id =~ /^[a-z\d]+$/
    status 400
    @mes = 'invalid tag'
  else
    @data = env['rack.request.form_vars']
    begin
      status 200
      @@cache.set(@id, @data, @@conf['expire'])
      @mes = @data
    rescue => e
      STDERR.puts e
      status 500
      @mes = e.to_s
    end
  end
end

get '/tag/:hex_id' do
  @id = params[:hex_id].downcase
  unless @id =~ /^[a-z\d]+$/
    status 400
    @mes = 'invalid tag'
  else
    begin
      status 200
      @mes = @@cache.get(@id)
    rescue Memcached::NotFound => e
      status 200
      @mes = ''
    end
  end
end

delete '/tag/:hex_id' do
  @id = params[:hex_id].downcase
  unless @id =~ /^[a-z\d]+$/
    status 400
    @mes = 'invalid tag'
  else
    begin
      status 200
      @mes = @@cache.set(@id, '')
    rescue => e
      STDERR.puts e
      status 500
      @mes = e.to_s
    end
  end
end
