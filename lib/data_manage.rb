require 'rubygems'
require 'json'
require_relative '../config/databse.rb'

class DataManage
    def initialize()
    end

    def measure_manage(topic,message)
        message = JSON.parse(message)
        @node = Node.find_by_id(topic[2])
        @group = Group.find_by_id(topic[1])
        if @node != nil && @group != nil
            check = @node.sensors.find_by_name(topic[5])
            if check != nil
                value = message[topic[5]]['value']
                unique_id = message[topic[5]]['unique_id']
                unique_id = /([a-z0-9])\w+/.match(unique_id)
                Measure.create(:data => value, :unit => check.units,:node => @node,:sensor => check)
                puts "Datos ingresados"
            else
                puts "Sensor de #{topic[5]} no pertenece a nodo #{@node.id}"
            end
        else
            puts "Datos incorrectos"
        end
    end

    def measure_ttn_manage(topic,message)
        message = JSON.parse(message)
        puts message['payload_fields']['data']
        # @node = Node.find_by_id(topic[2])
        # @group = Group.find_by_id(topic[1])
        # if @node != nil && @group != nil
        #     check = @node.sensors.find_by_name(topic[5])
        #     if check != nil
        #         value = message[topic[5]]['value']
        #         unique_id = message[topic[5]]['unique_id']
        #         unique_id = /([a-z0-9])\w+/.match(unique_id)
        #         Measure.create(:data => value, :unit => check.units,:node => @node,:sensor => check)
        #         puts "Datos ingresados"
        #     else
        #         puts "Sensor de #{topic[5]} no pertenece a nodo #{@node.id}"
        #     end
        # else
        #     puts "Datos incorrectos"
        # end
    end

    def heartbeat_manage(topic, message)
        @node = Node.find_by_id(topic[2])
        if @node != nil
            if message == 'up'
                @node.update(:status => true)
                puts "Nodo #{@node.id} up"
            elsif message == 'down'
                @node.update(:status => false)
                puts "Nodo #{@node.id} down"
            else
                puts "wrong message"
            end
            
        else
            puts "Nodo con id #{@node.id} no existe"
        end
    end


    def check(topic,message)
        puts "topic", topic
        puts "message", message
        topic = topic.split('/')
        if topic[3] == 'measures'
            measure_manage(topic,message)
        elsif topic[3] == 'status'
            if topic[4] == 'heartbeat'
                heartbeat_manage(topic,message)
            end
        elsif topic[1] == 'ttn'
            measure_ttn_manage(topic,message)
        else
            puts "Topico incorrecto"
        end
    end
end