# frozen_string_literal: true

module FrilansFinans
  module UserWrapper
    def self.attributes(user)
      attrs = {
        email: user.email,
        remote_id: user.id.to_s,
        street: user.street || '',
        city: user.city || '',
        zip: user.zip || '',
        country: user.country_name.upcase,
        cellphone: user.phone,
        first_name: user.first_name,
        last_name: user.last_name,
        show_name_in_network: false,
        receive_sms_notificiations: false,
        receive_email_notifications: false,
        notification_language: notification_language(user.system_language)
      }

      ssn = user.ssn

      attrs[:social_security_number] = format_ssn(ssn) if ssn.present?
      attrs[:account_clearing_number] = user.account_clearing_number if user.account_clearing_number.present? # rubocop:disable Metrics/LineLength
      attrs[:account_number] = user.account_number if user.account_number.present?

      attrs
    end

    def self.notification_language(language)
      return 'sv' if language.lang_code == 'sv'
      'en'
    end

    def self.format_ssn(ssn)
      ssn.delete('-')
    end
  end
end
