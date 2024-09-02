require 'rails_helper'

RSpec.describe "Comments on Posts", type: :request do
  include Devise::Test::IntegrationHelpers

  let!(:first_post) { create(:post) }
  let!(:user) { create(:user) }
  let(:valid_attributes) do
    { body: "Test comment body", user_id: user.id, post_id: first_post.id }
  end
  let(:invalid_attributes) do
    { ugly_body: "very ugly" }
  end

  describe "when user is signed in" do
    before do
      sign_in user
      create_list(:comment, 3, post: first_post, user: user, body: valid_attributes[:body])
    end

    describe "GET /posts/:id/comments (index comments)" do
      it "returns a successful response" do
        get post_comments_path(first_post)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("text/html; charset=utf-8")
      end

      it "returns the comments for the post" do
        get post_comments_path(first_post)

        assert_select '.comment', count: 3
        assert_select '.comment', /#{Regexp.escape(valid_attributes[:body])}/
      end
    end

    describe "GET post/:post_id/show" do
      it "renders a successful response" do
        comment = Comment.create! valid_attributes
        get post_comment_url(first_post, comment)
        expect(response).to be_successful
      end
    end

    describe "GET post/:post_id/new" do
      it "renders a successful response" do
        get new_post_comment_url(first_post)
        expect(response).to be_successful
      end
    end

    describe "POST posts/:post_id/comments (comment create)" do
      context "with valid parameters" do
        it "creates a new Comment and redirects to created comment page" do
          expect {
            post post_comments_url(first_post), params: { comment: valid_attributes }
          }.to change(Comment, :count).by(1)

          expect(response).to have_http_status(:redirect)
          follow_redirect!
          expect(response).to have_http_status(:success)
          assert_select '.comment', text: /#{Regexp.escape(valid_attributes[:body])}/
        end
      end

      context "with invalid parameters" do
        it "does not create a new Comment" do
          expect {
            post post_comments_url(first_post), params: { comment: invalid_attributes }
          }.to change(Comment, :count).by(0)
        end

        it "renders a response with 422 status (i.e. to display the 'new' template)" do
          post post_comments_path(first_post), params: { comment: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "GET post/:post_id/comments/:id/edit" do
      it "renders a successful response" do
        comment = Comment.create! valid_attributes
        get edit_post_comment_path(first_post, comment)
        expect(response).to be_successful
      end
    end

    describe "PATCH post/:post_id/comments/:id (update comment)" do
      context "with valid parameters" do
        let(:new_attributes) {
          { body: "Test comment body updated", user_id: user.id, post_id: first_post.id }
        }

        it "updates the requested comment" do
          comment = Comment.create! valid_attributes
          patch post_comment_path(first_post, comment), params: { comment: new_attributes }
          comment.reload
          expect(comment.body).to eq(new_attributes[:body])
        end

        it "redirects to the comment" do
          comment = Comment.create! valid_attributes
          patch post_comment_path(first_post, comment), params: { comment: new_attributes }
          comment.reload
          expect(response).to redirect_to(post_comment_url(first_post, comment))
        end
      end

      context "with invalid parameters" do
        it "renders a response with 422 status (i.e. to display the 'edit' template)" do
          comment = Comment.create! valid_attributes
          patch post_comment_path(first_post, comment), params: { comment: { body: '' } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "DELETE post/:post_id/comments/:id (destroy comment)" do
      it "destroys the requested comment" do
        comment = Comment.create! valid_attributes
        expect {
          delete post_comment_path(first_post, comment)
        }.to change(Comment, :count).by(-1)
      end

      it "redirects to the comments list" do
        comment = Comment.create! valid_attributes
        delete post_comment_path(first_post, comment)
        expect(response).to redirect_to(post_comments_url(first_post))
      end
    end
  end

  describe "when user in not signed in" do
    describe "POST post/:post_id/comments (create comment)" do
      it "doesn't create a comment" do
        expect {
          post post_comments_path(first_post), params: { comment: valid_attributes }
        }.to change(Comment, :count).by(0)

        expect(response).to have_http_status(:redirect)
      end
    end
  end
end
