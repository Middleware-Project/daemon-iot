require 'daemons'

pwd  = File.dirname(File.expand_path(__FILE__))
file = pwd + '/lib/background_service.rb'

options = {
    :log_output => true
}
Daemons.run(file,options)


