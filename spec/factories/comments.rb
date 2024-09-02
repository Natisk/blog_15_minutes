# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    association :user
    association :post
    body { "Text of comment body" }
  end
end
