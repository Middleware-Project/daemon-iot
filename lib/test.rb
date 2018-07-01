require 'mqtt'
require 'yaml'

config = YAML.load_file(File.join(File.dirname(__FILE__),'../config/ttn_conf.yml'))
@TTN = MQTT::Client.connect(:host => config['server'],
    :port => config['port'],
    :username => config['username'],
    :password => config['password'],
    :ssl => config['ssl'],
    :ca_file => config['ca_file'])

p @TTN.connected?

@TTN.get('middleware/devices/+/up') do |topic,message|
    puts "#{topic}: #{message}"
end