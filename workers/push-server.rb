#!/usr/bin/env ruby
## POIのpush配信するサーバー
require 'rubygems'
require 'bundler/setup'
require 'eventmachine'
require 'evma_httpserver'
require 'memcached'
require 'yaml'
require 'ArgsParser'

begin
  @@conf = YAML::load open(File.dirname(__FILE__)+'/../config.yaml').read
  p @@conf
rescue => e
  STDERR.puts 'config.yaml load error!'
  STDERR.puts e
  exit 1
end

begin
  @@m = Memcached.new @@conf['memcached']
rescue => e
  STDERR.puts 'memcached error'
  STDERR.puts e
  exit 1
end

parser = ArgsParser.parser
parser.bind(:port, :p, 'HTTP comet port', 8932)
parser.comment(:timeout, 'comet timeout (sec)', 60)
parser.bind(:help, :h, 'show help')
first, params = parser.parse ARGV
if parser.has_option(:help)
  puts parser.help
  puts "e.g.  ruby comet-server.rb -port 8932 -timeout 60"
  exit 1
end

@@timeout = params[:timeout].to_i

class PoiPushServer < EventMachine::Connection
  include EventMachine::HttpServer
  
  def process_http_request
    res = EventMachine::DelegatedHttpResponse.new(self)
    puts "request_method : #{@http_request_method}"
    puts "path_info : #{@http_path_info}"
    puts "query_str : #{@http_query_string}"
    puts "post_content : #{@http_post_content}"
    tag = @http_path_info.gsub(/^\//,'').strip
    if @http_request_method == 'POST'
      data = @http_post_content
      @@m.set(tag, data, @@conf['expire'])
      res.status = 200
      res.content = data
      res.send_response
    elsif @http_request_method == 'GET'
      EM::defer do 
        @@timeout.times do ## keep connection
          begin
            data = @@m.get("to_#{tag}")
            break if data.to_s.size > 0
          rescue Memcached::NotFound => e
          end
          sleep 1
        end
        @@m.delete("to_#{tag}")
        @@m.set(tag, data, @@conf['expire'])
        res.status = 200
        res.content = data
        res.send_response
      end
    end
  end
end

EventMachine::run do
  EventMachine::start_server("0.0.0.0", params[:port].to_i, PoiPushServer)
  puts "http server start, port #{params[:port].to_i}"
end
