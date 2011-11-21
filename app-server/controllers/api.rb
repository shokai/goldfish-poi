## API for POI

post '/tag/:tag/:action' do
  @tag = params[:tag].downcase
  @action = params[:action]
  @poi = params['poi'].to_s.downcase
  if !(@tag =~ /^[a-z\d]+$/)
    status 400
    @mes = 'invalid tag'
  elsif !(@poi =~ /^[a-z\d]+$/)
    status 400
    @mes = 'invalid poi'
  else
    if @action =~ /^copy$/i
      begin
        data = @@cache.get(@tag)
        @@cache.set(@poi, data)
        status 200
        @mes = data
      rescue Memcached::NotFound => e
        status 200
        @mes = ''
      rescue => e
        STDERR.puts e
        status 500
        @mes = e.to_s
      end
    elsif @action =~ /^paste$/i
      begin
        data = @@cache.get(@poi)
        @@cache.set("to_#{@tag}", data, @@conf['expire'])
        status 200
        @mes = data
      rescue Memcached::NotFound => e
        status 200
        @mes = ''
      rescue => e
        STDERR.puts e
        status 500
        @mes = e.to_s
      end
    else
      status 400
      @mes = 'invaid action'
    end
  end
end

post '/tag/:tag' do
  @tag = params[:tag].downcase
  @data = env['rack.request.form_vars'].to_s
  if !(@tag =~ /^[a-z\d]+$/)
    status 400
    @mes = 'invalid tag'
  else
    begin
      @@cache.set(@tag, @data)
      status 200
      @mes = @data
    rescue => e
      STDERR.puts e
      status 500
      @mes = e.to_s
    end
  end
end

get '/tag/:tag' do
  @tag = params[:tag].downcase
  unless @tag =~ /^[a-z\d]+$/
    status 400
    @mes = 'invalid tag'
  else
    begin
      status 200
      @mes = @@cache.get(@tag)
    rescue Memcached::NotFound => e
      status 200
      @mes = ''
    end
  end
end

delete '/tag/:tag' do
  @tag = params[:tag].downcase
  unless @tag =~ /^[a-z\d]+$/
    status 400
    @mes = 'invalid tag'
  else
    begin
      status 200
      @mes = @@cache.set(@tag, '')
    rescue => e
      STDERR.puts e
      status 500
      @mes = e.to_s
    end
  end
end
