class WebhookService

  def self.publish!(event)
    webhooks_for(event).each { |webhook| send_payload!(webhook: webhook, event: event) }
  end

  def self.webhooks_for(event)
    return Webhook.none unless event && event.discussion
    Webhook.where(hookable: [event.discussion, event.discussion.group].compact)
  end

  def self.send_payload!(webhook:, event:)
    return false unless webhook.event_types.include? event.kind
    HTTParty.post webhook.uri, body: payload_for(webhook, event), headers: webhook.headers
  end

  def self.payload_for(webhook, event)
    WebhookSerializer.new(webhook_object_for(webhook, event), root: false).to_json
  end

  def self.webhook_object_for(webhook, event)
    "Webhooks::#{webhook.kind.classify}::#{event.kind.classify}".constantize.new(event)
  end

end
