# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Users::UserSkillsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      path = '/api/v1/users/1/skills'
      route_path = 'api/v1/users/user_skills#index'
      expect(get: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #show' do
      path = '/api/v1/users/1/skills/1'
      route_path = 'api/v1/users/user_skills#show'
      expect(get: path).to route_to(route_path, user_id: '1', user_skill_id: '1')
    end

    it 'routes to #create' do
      path = '/api/v1/users/1/skills'
      route_path = 'api/v1/users/user_skills#create'
      expect(post: path).to route_to(route_path, user_id: '1')
    end

    it 'routes to #destroy' do
      path = '/api/v1/users/1/skills/1'
      route_path = 'api/v1/users/user_skills#destroy'
      expect(delete: path).to route_to(route_path, user_id: '1', user_skill_id: '1')
    end
  end
end

# == Schema Information
#
# Table name: user_skills
#
#  id                   :integer          not null, primary key
#  user_id              :integer
#  skill_id             :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  proficiency          :integer
#  proficiency_by_admin :integer
#
# Indexes
#
#  index_user_skills_on_skill_id              (skill_id)
#  index_user_skills_on_skill_id_and_user_id  (skill_id,user_id) UNIQUE
#  index_user_skills_on_user_id               (user_id)
#  index_user_skills_on_user_id_and_skill_id  (user_id,skill_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (skill_id => skills.id)
#  fk_rails_...  (user_id => users.id)
#
