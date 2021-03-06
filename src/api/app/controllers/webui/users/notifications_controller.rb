class Webui::Users::NotificationsController < Webui::WebuiController
  before_action :require_login

  def index
    notification_type = params[:type]
    case notification_type
    when 'done'
      @notifications = Notification.with_notifiable.where(delivered: true)
                                   .for_subscribed_user(User.session)
    when 'reviews'
      @notifications = Notification.with_notifiable.not_marked_as_done
                                   .where(notifiable_type: 'Review')
                                   .for_subscribed_user(User.session)
    when 'comments'
      @notifications = Notification.with_notifiable.not_marked_as_done
                                   .where(notifiable_type: 'Comment')
                                   .for_subscribed_user(User.session)
    when 'state_changes'
      @notifications = Notification.with_notifiable.not_marked_as_done
                                   .where(notifiable_type: 'BsRequest')
                                   .where.not(bs_request_oldstate: nil)
                                   .for_subscribed_user(User.session)
    else
      @notifications = Notification.with_notifiable.not_marked_as_done
                                   .for_subscribed_user(User.session)
    end
  end

  def update
    notification = User.session.notifications.find(params[:id])
    authorize notification, policy_class: NotificationPolicy

    if notification.update(delivered: true)
      flash[:success] = 'Successfully marked the notification as done'
    else
      flash[:error] = "Couldn't mark the notification as done"
    end
    redirect_back(fallback_location: root_path)
  end
end
