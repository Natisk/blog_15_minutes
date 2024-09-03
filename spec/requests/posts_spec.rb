# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "/posts", type: :request do
  include Devise::Test::IntegrationHelpers

  let(:user) { create(:user) }
  let(:test_post) { create(:post) }
  let(:valid_attributes) {
    { title: "What is the weather today?", body: "Let's talk about weather!" }
  }
  let(:invalid_attributes) {
    { title: "", body: "" }
  }

  describe "when user is not signed in" do
    describe "GET /index" do
      it "renders a sign in path" do
        get posts_url
        expect(response).to_not be_successful
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET /show" do
      it "renders a sign in path" do
        get post_url(test_post)
        expect(response).to_not be_successful
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET /new" do
      it "renders a sign in path" do
        get new_post_url
        expect(response).to_not be_successful
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET /edit" do
      it "renders a sign in path" do
        get edit_post_url(test_post)
        expect(response).to_not be_successful
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "POST /create" do
      context "with valid parameters" do
        it "doesn't creates a new Post" do
          expect {
            post posts_url, params: { post: valid_attributes }
          }.to change(Post, :count).by(0)
        end

        it "redirects to the sign in path" do
          post posts_url, params: { post: valid_attributes }
          expect(response).to_not be_successful
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    describe "PATCH /update" do
      context "with valid parameters" do
        let(:new_attributes) {
          { title: "Why did you do that?", body: "Cmon bro" }
        }

        it "doesn't update the requested post and redirects to sign in path" do
          up_post = create(:post)
          patch post_url(up_post), params: { post: new_attributes }
          up_post.reload
          expect(up_post.title).to_not eq(new_attributes[:title])
          expect(response).to_not be_successful
          expect(response).to redirect_to(new_user_session_path)
        end
      end
    end

    describe "DELETE /destroy" do
      it "doesn't destroy the requested post and redirects to sign in path" do
        de_post = create(:post)
        expect {
          delete post_url(de_post)
        }.to change(Post, :count).by(0)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "when user is signed in" do
    before do
      sign_in user
    end

    describe "GET /index" do
      it "renders a posts index view" do
        get posts_url
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:index)
        expect(response.content_type).to eq("text/html; charset=utf-8")
      end
    end

    describe "GET /new" do
      it "renders a new post view" do
        get new_post_path
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:new)
      end
    end

    describe "GET /show" do
      it "renders a post show view" do
        get post_path(test_post)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:show)
      end
    end

    describe "POST /create" do
      context "with valid parameters" do
        it "creates a new Post" do
          expect {
            post posts_url, params: { post: valid_attributes }
          }.to change(Post, :count).by(1)
        end

        it "redirects to the post path" do
          post posts_url, params: { post: valid_attributes }
          expect(response).to redirect_to(post_path(assigns(:post)))
        end
      end

      context "with invalid parameters" do
        it "does not create a new Post" do
          expect {
            post posts_url, params: { post: invalid_attributes }
          }.to change(Post, :count).by(0)
        end

        it "renders a response with 422 status" do
          post posts_url, params: { post: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:new)
        end
      end
    end

    describe "GET /edit" do
      it "renders post edit view" do
        get edit_post_path(test_post)
        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:edit)
      end
    end

    describe "PATCH /update" do
      context "with valid attributes" do
        it "updates post record" do
          up_post = create(:post)
          patch post_path(up_post), params: { post: valid_attributes }
          up_post.reload
          expect(up_post.title).to eq(valid_attributes[:title])
          expect(up_post.body).to eq(valid_attributes[:body])
          expect(response).to redirect_to(post_path(assigns(:post)))
        end
      end

      context "with invalid attributes" do
        it "doesn't update post" do
          up_post = create(:post)
          patch post_path(up_post), params: { post: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response).to render_template(:edit)
          up_post.reload
          expect(up_post.title).to_not eq(invalid_attributes[:title])
          expect(up_post.body).to_not eq(invalid_attributes[:body])
        end
      end
    end

    describe "DELETE /delete" do
      it "deletes post" do
        de_post = create(:post)
        expect {
          delete post_path(de_post)
        }.to change(Post, :count).by(-1)
        expect(response).to redirect_to(posts_path)
      end
    end
  end
end
