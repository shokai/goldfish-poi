require 'rubygems'
require 'bundler/setup'
require 'rack'
require 'sinatra/reloader' if development?
require 'haml'
require 'yaml'
require 'json'
require 'memcached'
[:helpers, :models, :controllers].each do |dir|
  Dir.glob(File.dirname(__FILE__)+"/#{dir}/*.rb").each do |rb|
    puts "loading #{rb}"
    require rb
  end
end

begin
  @@conf = YAML::load open(File.dirname(__FILE__)+'/../config.yaml').read
  p @@conf
rescue => e
  STDERR.puts 'config.yaml load error!'
  STDERR.puts e
  exit 1
end

begin
  @@cache = Memcached.new @@conf['memcached']
rescue => e
  STDERR.puts 'memcached error'
  STDERR.puts e
  exit 1
end
