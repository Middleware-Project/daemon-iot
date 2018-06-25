require 'rubygems'
require 'mqtt'
require 'yaml'

ARGV.each do |arg|
    @server = arg
end

config = YAML.load_file(File.join(File.dirname(__FILE__),'../config/ttn_conf.yml'))
puts "Connecting..."
@client = MQTT::Client.connect(:host => config['server'],
    :port => config['port'],
    :username => config['username'],
    :password => config['password'],
    :ssl => config['ssl'],
    :ca_file => config['ca_file'],
    :cert_file => config['cert_file'],
    :key_file => config['key_file'])


if @client.connected?
    puts "MQTT Client up"
    @client.get('+/devices/+/up') do |topic,message|
        puts "#{topic}: #{message}"
        MQTT::Client.connect(:host => @server,:port => 1883) do |c|
            c.publish('backend/ttn', message)
        end
    end
else
    puts "Error..."
end

