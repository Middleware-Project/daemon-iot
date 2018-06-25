require 'rubygems'
require 'mqtt'
require 'yaml'
require_relative '../lib/data_manage.rb'
#require_relative '../db/databse.rb'

ARGV.each do |arg|
    @server = arg
end

config = YAML.load_file(File.join(File.dirname(__FILE__),'../config/ttn_conf.yml'))

@manage = DataManage.new()
puts "Connecting..."
@client = MQTT::Client.connect(:host => @server,:port => 1883)

if @client.connected?
    puts "MQTT Client up"
    @client.get('backend/#') do |topic,message|
        @manage.check(topic,message)
    end 
else
    puts "Error..."
end





