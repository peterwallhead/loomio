require 'rails_helper'

describe API::ReactionsController do
  let(:specific) { create :specific, specifiable: comment, key: :reactions, value: { user_a.username => 'user_a', user_b.username => 'user_b' } }
  let(:user_a) { create :user }
  let(:user_b) { create :user }
  let(:user_c) { create :user }
  let(:comment) { create :comment }

  before do
    comment.discussion.group.add_member! user_a
    comment.discussion.group.add_member! user_b
  end

  describe 'index' do

    it 'shows a list of reactions for a given comment' do
      sign_in user_a
      specific
      get :index, comment_id: comment.id
      json = JSON.parse(response.body)
      expect(json.keys.length).to eq 2
      expect(json[user_a.username]).to eq 'user_a'
      expect(json[user_b.username]).to eq 'user_b'
    end

    it 'returns unauthorized if the user cannot see the comment' do
      sign_in user_c
      get :index, comment_id: comment.id
      expect(response.status).to eq 403
    end
  end

  describe 'update' do

    it 'creates a new reaction for a user' do
      sign_in user_a
      post :update, comment_id: comment.id, reaction: 'reaction'
      expect(response.status).to eq 200
      expect(comment.reload.reaction_for(user_a)).to eq 'reaction'
    end

    it 'updates an existing reaction for a user' do
      specific
      sign_in user_a
      post :update, comment_id: comment.id, reaction: 'reaction'
      expect(response.status).to eq 200
      expect(comment.reload.reaction_for(user_a)).to eq 'reaction'
    end

    it 'does not allow unauthorized users to delete reactions' do
      sign_in user_c
      post :update, comment_id: comment.id
      expect(response.status).to eq 403
    end
  end

  describe 'destroy' do
    it 'removes an existing reaction by passing nil' do
      sign_in user_a
      delete :destroy, comment_id: comment.id
      expect(response.status).to eq 200
      expect(comment.reload.reaction_for(user_a)).to be_nil
    end

    it 'does not allow unauthorized users to delete reactions' do
      sign_in user_c
      delete :destroy, comment_id: comment.id
      expect(response.status).to eq 403
    end

  end
end
