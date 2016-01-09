module Plugins
  module LoomioWebhooks
    class Plugin < Plugins::Base

      setup! :loomio_webhooks do |plugin|
        plugin.enabled = true

        plugin.use_class_directory "app/models/webhooks/slack/"
        plugin.use_class "app/models/webhook"
        plugin.use_class "app/services/webhook_service"

        plugin.use_database_table :webhooks do |table|
          table.references :hookable, polymorphic: true, index: true
          table.string :kind, null: false
          table.string :uri, null: false
          table.text   :event_types, array: true, default: []
          table.timestamps
        end

        plugin.use_events do |event_bus|
          event_bus.listen('motion_outcome_created_event',
                           'motion_outcome_updated_event',
                           'motion_closing_soon_event',
                           'motion_closed_event',
                           'new_discussion_event',
                           'new_motion_event',
                           'new_vote_event') { |event| WebhookService.delay.publish!(event) }
        end
      end
    end
  end
end
