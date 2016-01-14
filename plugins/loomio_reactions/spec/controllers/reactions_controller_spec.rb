require 'rails_helper'

describe API::ReactionsController do
  let(:specific) { create :specific, specifiable: comment, key: :reactions, value: { user_a.username => 'reaction_a', user_b.username => 'reaction_b' } }
  let(:user_a) { create :user }
  let(:user_b) { create :user }
  let(:user_c) { create :user }
  let(:discussion) { create :discussion }
  let(:another_comment) { create :comment }
  let(:comment) { create :comment, discussion: discussion }

  before do
    discussion.group.add_member! user_a
    discussion.group.add_member! user_b
  end

  # sample output:
  # [<comment_id>: {
  #   <emoji_name>: [<username>, <username>],
  #   <emoji_name>: [<username, username>]
  # },
  # <comment_id>: {
  #   <emoji_name>: [<username>, <username>],
  #   <emoji_name>: [<username, username>]
  # }]

  describe 'index' do

    it 'shows a list of reactions for a given comment' do
      sign_in user_a
      specific
      get :index, discussion_id: discussion.id

      json = JSON.parse(response.body)
      expect(json.keys).to include comment.id
      expect(json.keys).to_not include comment.id

      comment_json = json[comment.id]
      expect(comment_json.keys).to include 'reaction_a'
      expect(comment_json.keys).to include 'reaction_b'
      expect(comment_json.keys).to_not include 'reaction_c'

      reaction_json = comment_json['reaction_a']
      expect(reaction_json).to include user_a.username
      expect(reaction_json).to include user_b.username
      expect(reaction_json).to_not include user_c.username
    end

    it 'returns unauthorized if the user cannot see the comment' do
      sign_in user_c
      get :index, discussion_id: discussion.id
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

    it 'does not allow a duplicate reaction' do
      specific
      sign_in user_a
      post :update, comment_id: comment.id, reaction: 'reaction'
      expect(response.status).to eq 422
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
