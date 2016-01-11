module Plugins
  module LoomioReactions
    class Plugin < Plugins::Base

      setup! :loomio_reactions do |plugin|
        plugin.enabled = true

        # plugin.use_component :reaction_form
        # plugin.use_component :reaction_display

        plugin.use_class 'controllers/reactions_controller'

        plugin.extend_class Comment do
          def reaction_for(user)
            reactions.value[user.username]
          end

          def set_reaction_for(user, reaction)
            reactions.value[user.username] = reaction
            reactions.save
          end

          private

          def reactions
            @reactions ||= specifics.find_or_initialize_by(key: :reactions)
          end
        end

        plugin.use_route :get,    '/reactions', 'reactions#index'
        plugin.use_route :post,   '/reactions', 'reactions#update'
        plugin.use_route :delete, '/reactions', 'reactions#destroy'

      end
    end
  end
end
