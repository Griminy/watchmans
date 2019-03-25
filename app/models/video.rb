class Video < ApplicationRecord
  
  belongs_to :customer
  has_many :streams
  validates_presence_of :name, :duration

  scope :in_process, -> do (customer = nil)
    hooks_ids = Hook.actual.select :video_id
    current   = Video.where id: hooks_ids
    current   = current.where(customer: customer) if customer.present?
    current
  end

end