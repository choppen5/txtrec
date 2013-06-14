class Registration < ActiveRecord::Base
  belongs_to :user
  attr_accessible :regname, :renumber
end
