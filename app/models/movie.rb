class Movie < ActiveRecord::Base
  has_many :reviews
  before_save :capitalize_title
  def capitalize_title
    self.title = self.title.split(/\s+/).map(&:downcase).
      map(&:capitalize).join(' ')
  end
  def self.all_ratings ; %w[G PG PG-13 R NC-17] ; end #  shortcut: array of strings
  validates :title, :presence => true
  validates :release_date, :presence => true
  validate :released_1930_or_later # uses custom validator below
  validates :rating, :inclusion => {:in => Movie.all_ratings},
    :unless => :grandfathered?
  def released_1930_or_later
    errors.add(:release_date, 'must be 1930 or later') if
      release_date && release_date < Date.parse('1 Jan 1930')
  end
  @@grandfathered_date = Date.parse('1 Nov 1968')
  def grandfathered?
    release_date && release_date < @@grandfathered_date
  end
  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      where(rating: ratings.map(&:upcase)).order sort_by
    end
  end
end
