#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'
require 'em-http'
require 'net/http'
require 'uri'
require 'ArgsParser'

parser = ArgsParser.parser
parser.comment(:tag, 'NFC Tag')
parser.comment(:api, 'POI comet API', 'http://ubif.org:8932')
parser.bind(:help, :h, 'show help')
first, params = parser.parse(ARGV)

if parser.has_option(:help) or !parser.has_params([:tag])
  puts parser.help
  puts 'e.g.  ruby mac-poi-client.rb -tag a1bcd234 -api "http://ubif.org:8932"'
  exit 1
end

api = "#{params[:api]}/#{params[:tag]}"

EM::run do

  EM::defer do
    loop do
      puts "* GET"
      uri = URI.parse api
      begin
        res = Net::HTTP.start(uri.host, uri.port).get(uri.path)
      rescue StandardError, Timeout::Error => e
        next
      end
      puts "GET code:#{res.code}"
      puts "GET data:#{res.body}"
      if res.code.to_i == 200
        data = res.body.strip
        escaped = data.gsub(/(["])/,'\\1')
        `echo "#{escaped}" | pbcopy`
        system "open #{data}" if data =~ /^https?:\/\/.+/
      end
      sleep 3
    end
  end

  data_p = nil
  EM::defer do
    loop do
      data = `pbpaste`
      data.strip!
      if data.to_s.size > 0 && data != data_p
        post_data = {:body => data}
        puts "* POST clipbard:#{data}"
        http = EM::HttpRequest.new(api).post(post_data)
        http.callback do |res|
          puts "POST success"
          puts res.response_header.status
          puts res.response
        end
        http.errback do |err|
          puts "POST error"
          puts err.response_header.status
          puts err.error
          puts err.response
        end
        data_p = data
      end
      sleep 3
    end
  end
end
