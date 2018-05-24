class ChurchGuide < ApplicationRecord

  belongs_to :church
  belongs_to :guide

  validates :promoted, :owner, inclusion: { in: [true, false] }

end
