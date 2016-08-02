class Root < ApplicationRecord
  has_many :archives, dependent: :destroy
end
