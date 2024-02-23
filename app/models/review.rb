class Review < ActiveRecord::Base
  belongs_to :movie
  belongs_to :moviegoer
  attr_protected :moviegoer_id
  validates :movie_id, :presence => true
  validates_associated :movie
end
