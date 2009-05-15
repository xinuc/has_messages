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

      def inbox
        Message.find_received_messages self
      end

      def new_messages
        Message.find_unread_received_messages self
      end

      def has_new_messages?
        self.new_messages.count > 0
      end

      def outbox
        Message.find_sent_messages self
      end

      def read_message(message_id)
        Message.read_message self, message_id
      end

      def send_message(receiver, subject, body)
        Message.new(:receiver => receiver, :sender => self, :subject => subject,
          :body => body).save!
      end

      def delete_message(message_id)
        Message.trash_message self, message_id
      end
      
    end
  end
end