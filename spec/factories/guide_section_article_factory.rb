# frozen_string_literal: true

FactoryBot.define do
  factory :guide_section_article do
    language nil
    association :section, factory: :guide_section
  end
end

# == Schema Information
#
# Table name: guide_section_articles
#
#  id               :bigint(8)        not null, primary key
#  language_id      :bigint(8)
#  guide_section_id :bigint(8)
#  order            :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_guide_section_articles_on_guide_section_id  (guide_section_id)
#  index_guide_section_articles_on_language_id       (language_id)
#
# Foreign Keys
#
#  fk_rails_...  (guide_section_id => guide_sections.id)
#  fk_rails_...  (language_id => languages.id)
#
