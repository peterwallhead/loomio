require 'rails_helper'

describe Comment do
  describe 'reactions' do

    let(:user) { create(:user) }
    let(:comment) { create(:comment) }
    let(:reactions) { create(:specific, specifiable: comment, key: :reactions) }
    let(:reaction_text) { 'smiley' }

    before { comment.discussion.group.add_member! user }

    describe 'reaction_for' do
      it 'returns the reaction for the given user' do
        reactions.update(value: { user.username => reaction_text })
        expect(comment.reaction_for(user)).to eq reaction_text
      end

      it 'returns nil when no reaction exists' do
        expect(comment.reaction_for(user)).to be_nil
      end
    end

    describe 'set_reaction_for' do
      it 'sets the reaction for a user' do
        comment.set_reaction_for(user, reaction_text)
        expect(comment.reload.reaction_for(user)).to eq reaction_text
      end

      it 'replaces an existing reaction' do
        reactions.update(value: { user.username => 'old_reaction' })
        comment.set_reaction_for(user, reaction_text)
        expect(comment.reload.reaction_for(user)).to eq reaction_text
      end

      it 'can remove an existing reaction' do
        reactions.update(value: { user.username => 'old_reaction' })
        comment.set_reaction_for(user, nil)
        expect(comment.reload.reaction_for(user)).to be_nil
      end
    end
  end
end
