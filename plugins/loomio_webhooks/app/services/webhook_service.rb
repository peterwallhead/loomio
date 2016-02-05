class Plugins::LoomioWebhooks::WebhookService

  def self.publish!(event)
    webhooks_for(event).each { |webhook| send_payload!(webhook: webhook, event: event) }
  end

  def self.webhooks_for(event)
    return Webhook.none unless event && event.discussion
    [Webhook.find_by(hookable: event.discussion), Webhook.find_by(hookable: event.discussion.group)].compact
  end
  private_class_method :webhooks_for

  def self.send_payload!(webhook:, event:)
    return false unless webhook.event_types.include? event.kind
    HTTParty.post webhook.uri, body: payload_for(webhook, event), headers: webhook.headers
  end
  private_class_method :send_payload!

  def self.payload_for(webhook, event)
    WebhookSerializer.new(webhook_object_for(webhook, event), root: false).to_json
  end
  private_class_method :payload_for

  def self.webhook_object_for(webhook, event)
    "Plugins::LoomioWebhooks::#{webhook.kind.classify}::#{event.kind.classify}".constantize.new(event)
  end
  private_class_method :webhook_object_for

end
