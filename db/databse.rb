require 'rubygems'
require 'active_record'
require 'yaml'

config = YAML.load_file(File.join(File.dirname(__FILE__),'../config/database_conf.yml'))

ActiveRecord::Base.establish_connection(  
  :adapter => config['development']['adapter'],  
  :host => config['development']['host'],  
  :database => config['development']['database']  
) 

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

class Node < ApplicationRecord
  belongs_to :group
  has_and_belongs_to_many :sensors
end

class Group < ApplicationRecord
  validates :name,:description , presence: true
  has_many :nodes
end

class Sensor < ApplicationRecord
  has_and_belongs_to_many :nodes
end

class Measure < ApplicationRecord
  belongs_to :node
  belongs_to :sensor
end