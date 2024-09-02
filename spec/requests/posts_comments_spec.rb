require 'rails_helper'

RSpec.describe "Comments on Posts", type: :request do
  include Devise::Test::IntegrationHelpers

  let!(:first_post) { create(:post) }
  let!(:user) { create(:user) }
  let(:valid_attributes) do
    { body: "test comment body", user_id: user.id, post_id: first_post.id }
  end
  let(:invalid_attributes) do
    { ugly_body: "very ugly" }
  end

  describe "GET /posts/:id/comments (index comments)" do
    let(:comment_body) { "Text of comment" }

    before do
      sign_in user
      create_list(:comment, 3, post: first_post, user: user, body: comment_body)
    end

    it "returns a successful response" do
      get post_comments_path(first_post)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("text/html; charset=utf-8")
    end

    it "returns the comments for the post" do
      get post_comments_path(first_post)

      assert_select '.comment', count: 3
      assert_select '.comment', /Text of comment/
    end
  end

  describe "POST /posts/:id/comments" do
    describe "when user is authorized" do
      before do
        sign_in user
      end

      it "creates a new comment" do
        expect {
          post("/posts/#{first_post.id}/comments", params: { comment: valid_attributes })
        }.to change(Comment, :count).by(1)

        expect(response).to have_http_status(:redirect)
        follow_redirect!
        expect(response).to have_http_status(:success)
        assert_select '.comment', text: /test comment body/
      end
    end

    describe "when user is a guest" do
      it "doesn't create a comment" do
        expect {
          post("/posts/#{first_post.id}/comments", params: { comment: valid_attributes })
        }.to change(Comment, :count).by(0)

        expect(response).to have_http_status(:redirect)
      end
    end
  end

  # describe "GET /index" do
  #   it "renders a successful response" do
  #     Comment.create! valid_attributes
  #     get comments_url
  #     expect(response).to be_successful
  #   end
  # end

  # describe "GET /show" do
  #   it "renders a successful response" do
  #     comment = Comment.create! valid_attributes
  #     get comment_url(comment)
  #     expect(response).to be_successful
  #   end
  # end

  # describe "GET /new" do
  #   it "renders a successful response" do
  #     get new_comment_url
  #     expect(response).to be_successful
  #   end
  # end

  # describe "GET /edit" do
  #   it "renders a successful response" do
  #     comment = Comment.create! valid_attributes
  #     get edit_comment_url(comment)
  #     expect(response).to be_successful
  #   end
  # end

  describe "POST posts/:post_id/comments (comment create)" do
    context "when user signed in" do
      before do
        sign_in user
      end

      context "with valid parameters" do
        it "creates a new Comment" do
          expect {
            post post_comments_url(first_post), params: { comment: valid_attributes }
          }.to change(Comment, :count).by(1)
        end

        it "redirects to the created comment" do
          post post_comments_url(first_post), params: { comment: valid_attributes }
          expect(response).to redirect_to(post_comment_url(first_post, Comment.last))
        end
      end

      context "with invalid parameters" do
        it "does not create a new Comment" do
          expect {
            post post_comments_url(first_post), params: { comment: invalid_attributes }
          }.to change(Comment, :count).by(0)
        end

        it "renders a response with 422 status (i.e. to display the 'new' template)" do
          post post_comments_url(first_post), params: { comment: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    # context "when user in not signed in" do

    # end
  end

  # describe "PATCH /update" do
  #   context "with valid parameters" do
  #     let(:new_attributes) {
  #       skip("Add a hash of attributes valid for your model")
  #     }

  #     it "updates the requested comment" do
  #       comment = Comment.create! valid_attributes
  #       patch comment_url(comment), params: { comment: new_attributes }
  #       comment.reload
  #       skip("Add assertions for updated state")
  #     end

  #     it "redirects to the comment" do
  #       comment = Comment.create! valid_attributes
  #       patch comment_url(comment), params: { comment: new_attributes }
  #       comment.reload
  #       expect(response).to redirect_to(comment_url(comment))
  #     end
  #   end

  #   context "with invalid parameters" do
  #     it "renders a response with 422 status (i.e. to display the 'edit' template)" do
  #       comment = Comment.create! valid_attributes
  #       patch comment_url(comment), params: { comment: invalid_attributes }
  #       expect(response).to have_http_status(:unprocessable_entity)
  #     end
  #   end
  # end

  # describe "DELETE /destroy" do
  #   it "destroys the requested comment" do
  #     comment = Comment.create! valid_attributes
  #     expect {
  #       delete comment_url(comment)
  #     }.to change(Comment, :count).by(-1)
  #   end

  #   it "redirects to the comments list" do
  #     comment = Comment.create! valid_attributes
  #     delete comment_url(comment)
  #     expect(response).to redirect_to(comments_url)
  #   end
  # end
end
