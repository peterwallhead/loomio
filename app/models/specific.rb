class Specific < ActiveRecord::Base
  belongs_to :specifiable, polymorphic: true

  validates :specifiable, presence: true
  validates :key, presence: true, uniqueness: { scope: :specifiable }
end
