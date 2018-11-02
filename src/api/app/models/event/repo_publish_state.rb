module Event
  class RepoPublishState < Base
    self.message_bus_routing_key = 'repo.publish_state'
    self.description = 'Publish State of Repository has changed'
    payload_keys :project, :repo, :state
    after_create_commit :send_to_bus
  end
end

# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  eventtype   :string(255)      not null, indexed
#  payload     :text(65535)
#  created_at  :datetime         indexed
#  updated_at  :datetime
#  undone_jobs :integer          default(0)
#  mails_sent  :boolean          default(FALSE), indexed
#
# Indexes
#
#  index_events_on_created_at  (created_at)
#  index_events_on_eventtype   (eventtype)
#  index_events_on_mails_sent  (mails_sent)
#
