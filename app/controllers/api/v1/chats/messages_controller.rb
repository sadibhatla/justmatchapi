# frozen_string_literal: true
module Api
  module V1
    module Chats
      class MessagesController < BaseController
        before_action :require_user
        before_action :set_chat

        after_action :verify_authorized, only: []

        resource_description do
          resource_id 'chat_messages'
          api_versions '1.0'
          name 'Chat messages'
          short 'API for managing chat messages'
          description '
            Create and list chat messages.
          '
          formats [:json]
        end

        ALLOWED_INCLUDES = %w(author language).freeze

        api :GET, '/chats/:chat_id/messages', 'Get chat messages.'
        description 'Returns messages in chat.'
        error code: 404, desc: 'Not found'
        ApipieDocHelper.params(self, Index::MessagesIndex)
        example Doxxer.read_example(Message, plural: true)
        def index
          messages_index = Index::MessagesIndex.new(self)
          @messages = messages_index.messages(@chat.messages)

          api_render(@messages, total: messages_index.count)
        end

        api :POST, '/chats/:chat_id/messages', 'Create new chat message.'
        description 'Creates and returns new message.'
        error code: 400, desc: 'Bad request'
        error code: 404, desc: 'Not found'
        error code: 422, desc: 'Unprocessable entity'
        param :data, Hash, desc: 'Top level key', required: true do
          param :attributes, Hash, desc: 'Message attributes', required: true do
            param :body, String, desc: 'Message body', required: true
            param :language_id, Integer, desc: 'Language id', required: true
          end
        end
        ApipieDocHelper.params(self)
        example Doxxer.read_example(Message, method: :create)
        def create
          @message = CreateChatMessageService.create(
            chat: @chat,
            author: current_user,
            body: message_params[:body],
            language_id: message_params[:language_id]
          )

          if @message.valid?
            api_render(@message, status: :created)
          else
            api_render_errors(@message)
          end
        end

        private

        def set_chat
          @chat = current_user.chats.find(params[:id])
        end

        def message_params
          jsonapi_params.permit(:body, :language_id)
        end
      end
    end
  end
end
