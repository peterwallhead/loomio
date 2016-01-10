Loomio::Application.routes.append do
  namespace :api, path: '/api/v1', defaults: {format: :json} do
    get 'proposals/:id/descriptions' => 'motions#descriptions'
  end
end
