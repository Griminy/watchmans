class Hook < ApplicationRecord
  
  has_one :video
  has_one :customer
  validates_presence_of :video_id, :customer_id

  scope :actual, -> { self.where('created_at >= ?', 6.seconds.ago) }

end