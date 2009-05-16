module Xinuc
  module HasMessages

    def self.included( recipient )
      recipient.extend( Xinuc::HasMessages::ModelClassMethods )
    end

    module ModelClassMethods

      def has_messages
        include Xinuc::HasMessages::ModelInstanceMethods
      end
      
    end

    module ModelInstanceMethods

      def inbox(options = {})
        Message.find_received_messages self, options
      end

      def new_messages(options = {})
        Message.find_unread_received_messages self, options
      end

      def has_new_messages?
        self.new_messages.count > 0
      end

      def outbox(options = {})
        Message.find_sent_messages self, options
      end

      def read_message(message_id)
        Message.read_message self, message_id
      end

      def send_message(receiver, subject, body)
        Message.new(:receiver => receiver, :sender => self, :subject => subject,
          :body => body).save
      end

      def delete_message(message_id)
        Message.trash_message self, message_id
      end
      
    end
  end
end
