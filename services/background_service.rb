require 'rubygems'
require 'mqtt'
require 'yaml'
require_relative '../lib/data_manage.rb'
require_relative '../lib/ttnconnect.rb'

ARGV.each do |arg|
    @server = arg
end

# Se crea un thread con el cliente conectado a TTN
thr = Thread.new { 
    puts "Run Thread"
    @ttn = TTNConnect.new(@server)
    @ttn.run()
}

sleep(3)
puts "Wating..."
puts "- - - - - - - -"

config = YAML.load_file(File.join(File.dirname(__FILE__),'../config/ttn_conf.yml'))

@manage = DataManage.new()
puts "Connecting to mosquitto..."
@client = MQTT::Client.connect(:host => @server,:port => 1883)

if @client.connected?
    puts "Mosquitto MQTT Client up"
    puts "- - - - - - - -"
    puts "Data"
    @client.get('backend/#') do |topic,message|
        @manage.check(topic,message)
    end 
else
    puts "Error Mosquitto client"
end





