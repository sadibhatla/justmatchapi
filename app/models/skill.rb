# frozen_string_literal: true
class Skill < ApplicationRecord
  belongs_to :language

  has_many :job_skills
  has_many :jobs, through: :job_skills

  has_many :user_skills
  has_many :users, through: :user_skills

  validates :name, uniqueness: true, length: { minimum: 3 }, allow_blank: false, on: :create # rubocop:disable Metrics/LineLength
  validates :language, presence: true

  scope :visible, -> { where(internal: false) }

  include Translatable
  translates :name

  def self.to_form_array(include_blank: false)
    form_array = with_translations.
                 order('skill_translations.name').
                 map { |skill| [skill.name, skill.id] }

    return form_array unless include_blank

    [[I18n.t('admin.form.no_skill_chosen'), nil]] + form_array
  end

  def display_name
    "##{id} #{name}"
  end
end

# == Schema Information
#
# Table name: skills
#
#  id          :integer          not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  language_id :integer
#  internal    :boolean          default(FALSE)
#  color       :string
#
# Indexes
#
#  index_skills_on_language_id  (language_id)
#  index_skills_on_name         (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_07eab65450  (language_id => languages.id)
#
