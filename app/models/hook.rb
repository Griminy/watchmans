class Hook < ApplicationRecord
  
  belongs_to :video
  belongs_to :customer
  validates_presence_of :video_id, :customer_id

  scope :actual, -> { self.where('created_at >= ?', 6.seconds.ago) }

end