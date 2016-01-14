require 'rails_helper'

describe Comment do
  describe 'reactions' do

    let(:user) { create(:user) }
    let(:comment) { create(:comment) }
    let(:reactions) { create(:specific, specifiable: comment, key: :reactions) }
    let(:reaction_text) { 'smiley' }

    before { comment.discussion.group.add_member! user }

    describe 'update_reaction_for' do
      it 'adds a reaction if it does not exist' do
        comment.update_reaction_for(user, reaction_text)
        expect(comment.reload.reactions.value[reaction_text]).to eq [user.username]
      end

      it 'removes an existing reaction if it exists' do
        reactions.update(value: { reaction_text => user.username })
        comment.update_reaction_for(user, reaction_text)
        expect(comment.reload.reactions.value[reaction_text]).to eq []
      end
    end
  end
end
