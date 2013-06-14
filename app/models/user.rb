class User < ActiveRecord::Base
  attr_accessible :name, :usernumber
    
  has_many :registrations
end
