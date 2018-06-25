require 'mqtt'
require 'yaml'

class TTNConnect

    def initialize(server)  
        # Instance variables
        @server = server
        puts "Connecting to TTN..."
        config = YAML.load_file(File.join(File.dirname(__FILE__),'../config/ttn_conf.yml'))
        @TTN = MQTT::Client.connect(:host => config['server'],
            :port => config['port'],
            :username => config['username'],
            :password => config['password'],
            :ssl => config['ssl'],
            :ca_file => config['ca_file'],
            :cert_file => config['cert_file'],
            :key_file => config['key_file'])
    end

    def run
        if @TTN.connected?
            puts "TTN MQTT Client up"
            @TTN.get('+/devices/+/up') do |topic,message|
                puts "#{topic}: #{message}"
                MQTT::Client.connect(:host => @server,:port => 1883) do |c|
                    c.publish('backend/ttn', message)
                end
            end
        else
            puts "Error TTN client"
        end        
    end
end