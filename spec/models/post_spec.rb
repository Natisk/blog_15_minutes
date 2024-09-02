require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { build(:post) }

  it "is not valid without a user" do
    new_post = Post.new(user: nil)
    expect(new_post).not_to be_valid
    expect(new_post.errors[:user]).to include("must exist")
  end

  it "is valid with user" do
    expect(post).to be_valid
  end
end
