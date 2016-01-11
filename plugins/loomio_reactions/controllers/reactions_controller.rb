class API::ReactionsController < API::RestfulController

  def index
    load_and_authorize(:comment)
    respond_with_reactions
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

  def set_reaction(reaction)
    load_and_authorize(:comment, :like).set_reaction_for(current_user, reaction)
  end

  def respond_with_reactions
    render json: @comment.reactions.value
  end

end
