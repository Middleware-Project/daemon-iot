require 'rubygems'
require 'json'
require_relative '../db/databse.rb'

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
        if message['payload_fields']['data'] == 'update'
            puts "Update node"
        else
            @node = Node.find_by_unique_id(message['dev_id'])
            if @node != nil
                sensor = message['payload_fields']['data']['sensor']
                check = @node.sensors.find_by_name(sensor)
                if check != nil
                    value = message['payload_fields']['data']['value']
                    Measure.create(:data => value, :unit => check.units,:node => @node,:sensor => check)
                    puts "Datos ingresados"
                else
                    puts "Sensor de #{sensor} no pertenece a nodo #{@node.unique_id}"
                end
            else
                puts "El nodo #{message['dev_id']} no se encuentra"
            end
        end
    end

    def lora_update(topic,message)
        message = JSON.parse(message)
        @node = Node.find_by_unique_id(message['dev_id'])
        if @node != nil
            @app_id = message['app_id']
            @modulation = message['metadata']['modulation']
            @frequency = message['metadata']['frequency']
            @data_rate = message['metadata']['data_rate']
            message['gateways'].each do |gateway|
                @gateway_id = gateway['gtw_id']
            end
            @node.update(:app_id => @app_id,:modulation => @modulation,
                :frequency => @frequency,:data_rate => @data_rate,
                :gateway_id => @gateway_id)
            if @node.save
                puts "Node update"
            else
                puts "El nodo #{message['dev_id']} fue actualizado"
            end
        else
            puts "El nodo #{message['dev_id']} no se encuentra"
        end
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