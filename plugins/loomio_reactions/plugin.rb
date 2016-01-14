module Plugins
  module LoomioReactions
    class Plugin < Plugins::Base

      setup! :loomio_reactions do |plugin|
        plugin.enabled = true

        plugin.use_component :reaction_fetcher,     outlet: :thread_page_column_right
        plugin.use_component :reaction_display,     outlet: :after_comment_event
        plugin.use_component :reaction_form_header, outlet: :before_comment_dropdown
        plugin.use_component :reaction_form_footer

        plugin.use_class 'controllers/reactions_controller'

        plugin.extend_class Comment do

          def reactions
            @reactions ||= specifics.find_or_initialize_by(key: :reactions)
          end

          def update_reaction_for(user, reaction)
            reactions.value[reaction] = if reactions_for(reaction).include?(user.username)
              Array(reactions.value[reaction]) - Array(user.username)
            else
              Array(reactions.value[reaction]) + Array(user.username)
            end
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
