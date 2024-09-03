# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

  subject { described_class.new(body: "Text written by a user",
                                post_id: post.id,
                                user_id: user.id) }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without body" do
    subject.body = ""
    expect(subject).to_not be_valid
  end

  it "is not valid without user" do
    subject.user_id = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without post" do
    subject.post_id = nil
    expect(subject).to_not be_valid
  end
end
