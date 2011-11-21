#!/usr/bin/env ruby
require 'rubygems'
require 'eventmachine'
require 'em-http'
require 'net/http'
require 'uri'

EM::run do

  EM::defer do
    loop do
      puts "* GET"
      uri = URI.parse 'http://localhost:8932/a34b0ac7'
      begin
        res = Net::HTTP.start(uri.host, uri.port).get(uri.path)
      rescue StandardError, Timeout::Error => e
        STDERR.puts e
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
      sleep 1
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
        http = EM::HttpRequest.new('http://localhost:8932/a34b0ac7').post(post_data)
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
