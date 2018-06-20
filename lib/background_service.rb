require 'rubygems'
require 'mqtt'
require 'yaml'
require_relative 'data_manage.rb'
require_relative '../config/databse.rb'

ARGV.each do |arg|
    @server = arg
end

config = YAML.load_file(File.join(File.dirname(__FILE__),'../config/ttn_conf.yml'))

@manage = DataManage.new()
puts "Connecting"
@client = MQTT::Client.connect(:host => @server,:port => 1883)
puts "MQTT Client up"

@client.get('backend/#') do |topic,message|
    @manage.check(topic,message)
end

