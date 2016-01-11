class API::ReactionsController < API::RestfulController

  def index
    render json: load_and_authorize(:comment).specifics.find_or_initialize_by(key: :reactions).value
  end

  def update
    load_and_authorize(:comment, :like)
    @comment.set_reaction_for(current_user, params[:reaction])
    render json: @comment.reaction_for(current_user)
  end

end
