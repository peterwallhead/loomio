class API::ReactionsController < API::RestfulController

  def index
    render json: load_and_authorize(:comment).specifics.find_or_initialize_by(key: :reactions).value
  end

  def update
    render json: set_reaction(params[:reaction])
  end

  def destroy
    render json: set_reaction(nil)
  end

  private

  def set_reaction(reaction)
    load_and_authorize(:comment, :like)
    @comment.set_reaction_for(current_user, reaction)
  end

end
