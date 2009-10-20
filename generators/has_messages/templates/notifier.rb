class Notifier < ActionMailer::Base
  default_url_options[:host] = "localhost:3000"  

  def message_notification(message)
    subject       "You have incoming message"
    from          "youremail@email.com"
    recipients    message.receiver.email
    sent_on       Time.now
    body          :message => message
  end
end
