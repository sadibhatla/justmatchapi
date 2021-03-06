# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobTranslation, type: :model do
  subject do
    FactoryBot.build(
      :job_translation,
      name: 'Wat',
      short_description: 'Short',
      description: 'Desc',
      tasks_description: 'Task Desc',
      applicant_description: 'App Desc',
      requirements_description: 'Req Desc'
    )
  end

  it 'has TranslationModel as an ancestor' do
    expect(described_class.ancestors).to include(TranslationModel)
  end

  describe '#changed_translation_fields' do
    subject { FactoryBot.create(:job_translation) }

    it 'returns a list of changed translation attributes' do
      subject.name = 'Watwoman'
      expect(subject.changed_translation_fields).to eq(%w(name))
    end
  end

  describe '#unchanged_translation_fields' do
    subject { FactoryBot.create(:job_translation) }

    it 'returns a list of changed translation attributes' do
      subject.name = 'Watwoman'
      expected = %w(
        short_description description tasks_description applicant_description
        requirements_description
      )
      expect(subject.unchanged_translation_fields).to eq(expected)
    end
  end

  describe '#translates_model' do
    it 'returns job model' do
      expect(subject.translates_model).to be_a(Job)
    end
  end

  describe '#build_model_attributes' do
    it 'returns model attributes' do
      result = subject.translation_attributes
      expected = {
        'name' => 'Wat',
        'short_description' => 'Short',
        'description' => 'Desc',
        'tasks_description' => 'Task Desc',
        'applicant_description' => 'App Desc',
        'requirements_description' => 'Req Desc'
      }
      expect(result).to eq(expected)
    end
  end
end

# == Schema Information
#
# Table name: job_translations
#
#  id                       :integer          not null, primary key
#  locale                   :string
#  short_description        :string
#  name                     :string
#  description              :text
#  job_id                   :integer
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  language_id              :integer
#  tasks_description        :text
#  applicant_description    :text
#  requirements_description :text
#
# Indexes
#
#  index_job_translations_on_job_id       (job_id)
#  index_job_translations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (job_id => jobs.id)
#  fk_rails_...  (language_id => languages.id)
#
