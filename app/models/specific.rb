class Specific < ActiveRecord::Base
  belongs_to :specifiable, polymorphic: true

  validates :specifiable, presence: true
  validates :key, presence: true
  validates :value, uniqueness: { scope: :specifiable }
end
