# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user

  has_many :comments, inverse_of: :post
end
