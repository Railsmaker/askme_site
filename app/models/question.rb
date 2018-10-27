class Question < ApplicationRecord
  has_many :hashtag_questions, dependent: :destroy
  has_many :hashtags, through: :hashtag_questions
  belongs_to :user

  validates :text, presence: true
  before_save :create_hashtags

  def create_hashtags
    self.hashtag_questions.destroy_all

    tags = (text + ' ' + answer.to_s).scan(/#[[:word:]]+/i).uniq
    tags.each do |tag|
      self.hashtags << Hashtag.find_or_create_by!(tag: tag.delete!('#'))
    end
  end

end



