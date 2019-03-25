class Customer < ApplicationRecord
  
  has_one :stream
  has_many :videos

  validates :login, uniqueness: true, presence: true

end