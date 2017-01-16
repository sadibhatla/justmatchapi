# frozen_string_literal: true
class MessageUsers
  def self.call(type:, users:, template:, subject: nil, data: {})
    new(type, users, template, subject, data).call
  end

  def initialize(type, users, template, subject, data)
    @type = type
    @users = users
    @template = template
    @subject = subject
    @data = data
  end

  def call
    @users.each do |user|
      I18n.with_locale(user.locale) do
        response = MessageUser.call(
          type: @type,
          user: user,
          template: @template,
          subject: @subject,
          data: @data
        )
        return response unless response[:success]
      end
    end

    { success: true, message: "Sending #{type_name} to #{@users.length} user(s)." }
  end

  def type_name
    return 'both sms and email' if @type == 'both'
    @type
  end
end
