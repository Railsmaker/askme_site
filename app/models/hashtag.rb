class Hashtag < ApplicationRecord
  has_many :hashtag_questions
  has_many :questions, through: :hashtag_questions

  before_validation :tag_downcase
  validates :tag, uniqueness: true

  def tag_downcase
    self.tag = tag.downcase
  end

end

