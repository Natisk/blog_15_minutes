# frozen_string_literal: true

FactoryBot.define do
  factory :post do
    title { "Sample of Title" }
    body { "Sample of body text" }
    association :user
  end
end
