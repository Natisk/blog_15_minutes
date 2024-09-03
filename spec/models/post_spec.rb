# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }

  subject { described_class.new(title: "What are we gonna do?",
                                body: "Let's talk about what are we going to do today.",
                                user_id: user.id) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a title" do
    subject.title = ""
    expect(subject).to_not be_valid
    expect(subject.errors[:title]).to include("can't be blank")
  end

  it "is not valid without a body" do
    subject.body = ""
    expect(subject).to_not be_valid
    expect(subject.errors[:body]).to include("can't be blank")
  end

  it "is not valid without a user" do
    subject.user_id = nil
    expect(subject).to_not be_valid
    expect(subject.errors[:user]).to include("must exist")
  end
end
