class API::VersionsController < API::RestfulController

  private

  def resource_class
    PaperTrail::Version
  end

  def accessible_records
    load_and_authorize(params[:model]).versions.where(event: 'update').order(created_at: :desc)
  end

  def default_page_size
    100
  end
end
