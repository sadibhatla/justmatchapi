# frozen_string_literal: true

class JobUser < ApplicationRecord
  MAX_CONFIRMATION_TIME_HOURS = 24

  belongs_to :user
  belongs_to :job
  belongs_to :language, optional: true

  has_one :just_arrived_contact, through: :job
  has_one :company_contact, through: :job
  has_one :owner, through: :job
  has_one :company, through: :job
  has_one :invoice, dependent: :restrict_with_error
  has_one :frilans_finans_invoice, dependent: :restrict_with_error

  has_many :active_admin_comments, as: :resource, dependent: :destroy

  has_many :user_tags, through: :user
  has_many :tags, through: :user_tags

  has_many :user_skills, through: :user
  has_many :skills, through: :user_skills

  has_many :user_languages, through: :user
  has_many :languages, through: :user_languages

  has_many :user_occupations, through: :user
  has_many :occupations, through: :user_occupations

  validates :user, presence: true
  validates :job, presence: true

  validates :user, uniqueness: { scope: :job }
  validates :job, uniqueness: { scope: :user }

  validates :will_perform, after_true: { field: :accepted }, if: :will_perform
  validates :performed, after_true: { field: :will_perform }, if: :performed

  validates :accepted, unrevertable: true, unless: :applicant_confirmation_overdue?
  validates :will_perform, unrevertable: true
  validates :performed, unrevertable: true

  validate :validate_single_accepted_applicant
  validate :validate_applicant_not_owner_of_job
  validate :validate_job_started_before_performed

  before_validation :accepted_at_setter

  scope :long_list, (-> { unrejected.not_withdrawn.not_shortlisted.not_accepted })
  scope :unrejected, (-> { where(rejected: false) })
  scope :shortlisted, (-> { where(shortlisted: true) })
  scope :not_shortlisted, (-> { where(shortlisted: false) })
  scope :not_withdrawn, (-> { where(application_withdrawn: false) })
  scope :withdrawn, (-> { where(application_withdrawn: true) })
  scope :visible, (-> { unrejected.where(application_withdrawn: false) })
  scope :not_accepted, (-> { where(accepted: false) })
  scope :accepted, (-> { where(accepted: true) })
  scope :will_perform, (-> { where(will_perform: true) })
  scope :unconfirmed, (-> { accepted.where(will_perform: false) })
  scope :performed, (-> { where(performed: false) })
  scope :applicant_confirmation_overdue, (lambda {
    unconfirmed.where('accepted_at < ?', MAX_CONFIRMATION_TIME_HOURS.hours.ago)
  })
  scope :not_pre_reported, (lambda {
    will_perform.
      joins(:job).
      where('jobs.job_date < ?', Time.zone.now).
      where('jobs.direct_recruitment_job = ?', false).
      where('jobs.staffing_company_id IS NULL').
      left_joins(:frilans_finans_invoice).
      where('frilans_finans_invoices.id IS NULL OR frilans_finans_invoices.ff_approval_status IS NULL') # rubocop:disable Metrics/LineLength
  })

  include Translatable
  translates :apply_message

  def self.accepted_jobs_for(user)
    where(user: user, accepted: true).
      includes(:job).
      map(&:job)
  end

  def name
    "##{id} #{I18n.t('activerecord.models.job_user')}"
  end

  def current_status
    if job.started? && job.frilans_finans_job?
      return 'Not signed by user!' if accepted && !will_perform

      ff_status = frilans_finans_invoice&.ff_payment_status_name
      return ff_status if ff_status

      return 'Not pre-reported!'
    end

    return 'Withdrawn' if application_withdrawn
    return 'Will perform' if will_perform
    return 'Accepted' if accepted
    return 'Rejected' if rejected
    return 'Shortlisted' if shortlisted

    'Applied'
  end

  def application_status
    return :withdrawn if application_withdrawn
    return :hired if will_perform
    return :offered if accepted
    return :rejected if rejected

    :applied
  end

  def applicant_confirmation_overdue?
    return false if accepted_at.nil? || will_perform

    accepted_at < MAX_CONFIRMATION_TIME_HOURS.hours.ago
  end

  def will_perform_confirmation_by
    return if accepted_at.nil?

    accepted_at + MAX_CONFIRMATION_TIME_HOURS.hours
  end

  def validate_applicant_not_owner_of_job
    if job&.owner == user
      message = I18n.t('errors.job_user.not_owner_of_job')
      errors.add(:user, message)
    end
  end

  def validate_single_accepted_applicant
    accepted_user = self.class.accepted.find_by(job: job)&.user
    return if accepted_user.nil?
    return if user == accepted_user
    return unless accepted

    message = I18n.t('errors.job_user.multiple_applicants')
    errors.add(:accepted, message)
  end

  def accept
    self.accepted = true
  end

  def accepted_at_setter
    if accepted_changed? && accepted
      self.accepted_at = Time.zone.now
    end
  end

  def invoiced?
    !invoice.nil?
  end

  def validate_job_started_before_performed
    return if job&.started?
    return unless performed

    message = I18n.t('errors.job_user.performed_before_job_started')
    errors.add(:performed, message)
  end
end

# == Schema Information
#
# Table name: job_users
#
#  id                    :integer          not null, primary key
#  user_id               :integer
#  job_id                :integer
#  accepted              :boolean          default(FALSE)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  will_perform          :boolean          default(FALSE)
#  accepted_at           :datetime
#  performed             :boolean          default(FALSE)
#  apply_message         :text
#  language_id           :integer
#  application_withdrawn :boolean          default(FALSE)
#  shortlisted           :boolean          default(FALSE)
#  rejected              :boolean          default(FALSE)
#  http_referrer         :string(2083)
#  utm_source            :string
#  utm_medium            :string
#  utm_campaign          :string
#  utm_term              :string
#  utm_content           :string
#
# Indexes
#
#  index_job_users_on_job_id              (job_id)
#  index_job_users_on_job_id_and_user_id  (job_id,user_id) UNIQUE
#  index_job_users_on_language_id         (language_id)
#  index_job_users_on_user_id             (user_id)
#  index_job_users_on_user_id_and_job_id  (user_id,job_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (user_id => users.id)
#
