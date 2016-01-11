module Plugins
  module PositionSpecific
    class Plugin < Plugins::Base

      setup! :position_specific do |plugin|
        plugin.enabled = true

        plugin.use_component :position_fields, outlet: :after_proposal_form
        plugin.use_component :position_voting, outlet: :after_position_buttons

        plugin.use_route :get, 'proposals/:id/descriptions', 'motions#descriptions'

        plugin.extend_class API::MotionsController do
          def descriptions
            render json: load_and_authorize(:motion).specifics.find_by(key: :position_descriptions).try(:value) || {}
          end
        end

        plugin.extend_class PermittedParams do
          def motion_attributes
            proposal_attributes | [:agree_description, :abstain_description, :disagree_description, :block_description]
          end
        end

        plugin.extend_class Motion do
          attr_accessor :agree_description, :abstain_description, :disagree_description, :block_description

          def position_descriptions
            {
              agree_description:    self.agree_description,
              abstain_description:  self.abstain_description,
              disagree_description: self.disagree_description,
              block_description:    self.block_description
            }
          end

          def save_position_descriptions
            return unless position_descriptions.values.compact.any?
            specifics.find_or_initialize_by(key: :position_descriptions).update(value: position_descriptions)
          end
        end

        plugin.use_events do |event_bus|
          event_bus.listen('motion_create', 'motion_update') { |motion| motion.save_position_descriptions }
        end

        plugin.use_translations 'config/locales', :position_specific

      end
    end
  end
end
