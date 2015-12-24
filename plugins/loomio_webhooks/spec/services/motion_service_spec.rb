require 'rails_helper'

describe MotionService do
  let(:parent) { create :group }
  let(:group) { create(:group, parent: parent) }
  let(:discussion) { create :discussion, group: group }
  let(:motion) { build(:motion, discussion: discussion, author: user)}
  let(:user) { create(:user, email_on_participation: true) }
  let(:webhook_service) { Plugins::LoomioWebhooks::WebhookService }

  before { group.add_member! user }

  it 'calls the webhook with the motions discussion' do
    create :webhook, hookable: motion.discussion
    expect(webhook_service).to receive(:send_payload!)
    MotionService.create(motion: motion, actor: user)
  end

  it 'calls the webhook with the motions group' do
    create :webhook, hookable: motion.group
    expect(webhook_service).to receive(:send_payload!)
    MotionService.create(motion: motion, actor: user)
  end

  it 'does not call the webhook for the motions parent group' do
    create :webhook, hookable: parent
    expect(webhook_service).to receive(:publish!)
    expect(webhook_service).to_not receive(:send_payload!)
    MotionService.create(motion: motion, actor: user)
  end
end
