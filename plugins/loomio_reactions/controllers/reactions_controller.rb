class API::ReactionsController < API::RestfulController

  def index
    render json: discussion_reactions.map { |s| [s.specifiable_id, s.value] }.to_h
  end

  def update
    set_reaction(params[:reaction])
    respond_with_reactions
  end

  def destroy
    set_reaction(nil)
    respond_with_reactions
  end

  private

  def discussion_reactions
    Specific.where specifiable_type: "Comment",
                   specifiable_id: load_and_authorize(:discussion).comment_ids,
                   key: :reactions
  end

  def set_reaction(reaction)
    load_and_authorize(:comment, :like).set_reaction_for(current_user, reaction)
  end

  def respond_with_reactions
    render json: @comment.reactions.value
  end

end
