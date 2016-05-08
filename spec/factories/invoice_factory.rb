# frozen_string_literal: true
FactoryGirl.define do
  factory :invoice do
    sequence :frilans_finans_id do |n|
      n
    end

    association :job_user, factory: :job_user_passed_job

    factory :invoice_for_docs do
      id 1
      created_at Time.new(2016, 02, 10, 1, 1, 1).utc
      updated_at Time.new(2016, 02, 12, 1, 1, 1).utc
    end
  end
end

# == Schema Information
#
# Table name: invoices
#
#  id                :integer          not null, primary key
#  frilans_finans_id :integer
#  job_user_id       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_invoices_on_frilans_finans_id  (frilans_finans_id) UNIQUE
#  index_invoices_on_job_user_id        (job_user_id)
#  index_invoices_on_job_user_id_uniq   (job_user_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_c894e05ce5  (job_user_id => job_users.id)
#
