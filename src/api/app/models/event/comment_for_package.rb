module Event
  class CommentForPackage < Base
    include CommentEvent
    self.message_bus_routing_key = 'package.comment'
    self.description = 'New comment for package created'
    receiver_roles :maintainer, :bugowner, :watcher
    after_create_commit :send_to_bus
    payload_keys :project, :package, :sender

    def subject
      "New comment in package #{payload['project']}/#{payload['package']} by #{User.find(payload['commenter']).login}"
    end
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
