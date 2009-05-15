class Message < ActiveRecord::Base
  belongs_to :sender, :polymorphic => true
  belongs_to :receiver, :polymorphic => true

  validates_presence_of :receiver, :sender, :subject, :body

  class << self
    
    def find_received_messages(receiver, options = {})
      with_scope :find => options do
        find_all_by_receiver_id_and_receiver_type receiver.id, receiver.class.to_s,
          :conditions => { :trashed_by_receiver => false }, :order => 'created_at DESC'
      end
    end

    def find_unread_received_messages(receiver, options = {})
      options[:conditions] ||= {}
      options[:conditions].reverse_merge!(:read =>  false)
      find_received_messages(receiver, options)
    end

    def find_sent_messages(sender, options ={})
      with_scope :find => options do
        find_all_by_sender_id_and_sender_type sender.id, sender.class.to_s,
          :conditions => { :trashed_by_sender => false }, :order => 'created_at DESC'
      end
    end

    def read_message(user, id)
      returning message = find_by_id(id) do
        if(message && user == message.receiver)
          message.read = true
          message.save
        end
      end
    end

    def trash_message(user, id)
      message = find_by_id id
      if message
        if user == message.sender
          message.trashed_by_sender = true
        elsif user == message.receiver
          message.trashed_by_receiver = true
        end
        (message.trashed_by_sender && message.trashed_by_receiver) ? message.destroy : message.save
      end
    end

  end

  def sent_at
    created_at
  end
end
