require 'daemons'

pwd  = File.dirname(File.expand_path(__FILE__))
file = pwd + '/services/background_ttn_service.rb'

options = {
    :backtrace  => true,
    :log_dir => pwd + '/log',
    :log_output => true
}
Daemons.run(file,options)

