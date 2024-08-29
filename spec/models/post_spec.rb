require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { Post.new }

  describe "#user" do
    it "persists" do
      expect(create(post))
    end

    it "is required" do
      user = create(:user)

      expect(boat).to be_valid_with(user).as(:user)
      expect(boat).not_to be_valid_with(nil).as(:user)
    end
  end
end
