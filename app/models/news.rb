class News < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged


  belongs_to :admin

  validates :title, presence: true, uniqueness: true
  validates :body, presence: true
  validates :source, presence: true, uniqueness: true
  validates :header, presence: true, uniqueness: true
  validates :admin, presence: true
end
