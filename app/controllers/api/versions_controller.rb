class API::VersionsController < API::RestfulController

  private

  def accessible_records
    load_and_authorize(params[:model]).versions.where(event: 'update')
  end
end
