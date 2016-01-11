module Plugins
  module LoomioReactions
    class Plugin < Plugins::Base

      setup! :loomio_reactions do |plugin|
        plugin.enabled = true

        # plugin.use_component :reaction_form
        plugin.use_component :reaction_display, outlet: :after_comment_event

        plugin.use_class 'controllers/reactions_controller'

        plugin.extend_class Comment do
          def reactions
            @reactions ||= specifics.find_or_initialize_by(key: :reactions)
          end

          def reaction_for(user)
            reactions.value[user.username]
          end

          def set_reaction_for(user, reaction)
            reactions.value[user.username] = reaction
            reactions.save
          end
        end

        plugin.use_asset_directory :"emoji-one"

        plugin.use_route :get,  '/comments/:id/reactions', 'reactions#index'
        plugin.use_route :post, '/comments/:id/reactions', 'reactions#update'

      end
    end
  end
end
