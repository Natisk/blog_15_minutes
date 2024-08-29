# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "garna_#{n}@rich.ua" }
    password { "password" }
  end
end
