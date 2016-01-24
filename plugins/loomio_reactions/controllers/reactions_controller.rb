class API::ReactionsController < API::RestfulController

  def index
    render json: discussion_reactions
  end

  def update
    load_and_authorize(:comment, :like).update_reaction_for(current_user, params[:reaction])
    MessageChannelService.publish(comment_reactions, to: @comment.discussion)
    render json: comment_reactions
  end

  private

  def comment_reactions
    { reactions: @comment.reactions.value.merge(comment_id: @comment.id) }
  end

  def discussion_reactions
    Specific.where(specifiable_type: "Comment",
                   specifiable_id: load_and_authorize(:discussion).comment_ids,
                   key: :reactions).map { |s| [s.specifiable_id, s.value] }.to_h
  end

end
