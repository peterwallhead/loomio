module Plugins
  module LoomioReactions
    class Plugin < Plugins::Base

      setup! :loomio_reactions do |plugin|
        plugin.enabled = true

        plugin.use_component :reaction_fetcher,         outlet: :thread_page_column_right
        plugin.use_component :reaction_display,         outlet: :after_comment_event
        plugin.use_component :reaction_dropdown_option, outlet: :before_comment_dropdown
        plugin.use_component :reaction_form

        plugin.use_class 'controllers/reactions_controller'

        plugin.extend_class Comment do
          def reactions
            @reactions ||= specifics.find_or_initialize_by(key: :reactions)
          end

          def set_reaction_for(user, reaction)
            reactions.value[reaction] = Array(reactions.value[reaction]).push(user.username)
            reactions.save
          end

          private

          def reactions_for(reaction)
            Array(reactions.value[reaction])
          end
        end

        plugin.use_route :get,  '/discussions/:id/reactions', 'reactions#index'
        plugin.use_route :post, '/comments/:id/reactions', 'reactions#update'

      end
    end
  end
end
