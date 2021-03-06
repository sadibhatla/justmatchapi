# frozen_string_literal: true

ActiveAdmin.register Message do
  menu parent: 'Chats'

  batch_action :destroy, false

  index do
    selectable_column

    column :id
    column :original_body
    column :author
    column :chat
    column :language
    column :created_at

    actions
  end

  show do
    attributes_table do
      row :id
      row :author
      row :chat
      row(:body) { |chat| simple_format(chat.body) }
      row(:updated_at) { |chat| datetime_ago_in_words(chat.updated_at) }
      row(:created_at) { |chat| datetime_ago_in_words(chat.created_at) }
    end
  end

  include AdminHelpers::MachineTranslation::Actions

  set_message_translation = lambda do |message, permitted_params|
    return unless message.persisted? && message.valid?

    translation_params = {
      name: permitted_params.dig(:message, :body)
    }
    message.set_translation(translation_params)
  end

  after_save do |message|
    set_message_translation.call(message, permitted_params)
  end

  permit_params do
    %i(
      chat_id
      author_id
      language_id
      body
    )
  end

  controller do
    def scoped_collection
      super.with_translations.includes(:author, :chat, :language)
    end
  end
end
