class Loomio::Plugins::LoomioSlack < Loomio::Plugins::Base
  plugin_name :loomio_webhooks

  register_classes do

  end

  register_assets do

  end

  register_migrations do

  end

  register_events do |event_bus|
    event_bus.listen('motion_outcome_created_event',
                     'motion_outcome_updated_event',
                     'motion_closing_soon_event',
                     'motion_closed_event',
                     'new_discussion_event',
                     'new_motion_event',
                     'new_vote_event') { |event| WebhookService.delay.publish!(event) }
  end
end
