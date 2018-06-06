require 'active_record'

ActiveRecord::Base.establish_connection(  
:adapter => "postgresql",  
:host => "localhost",  
:database => "test3"  
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