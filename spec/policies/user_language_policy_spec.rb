# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserLanguagePolicy do
  before(:each) do
    allow_any_instance_of(User).to receive(:persisted?).and_return(true)
  end

  let(:user) { FactoryBot.build(:user) }
  let(:other_user) { FactoryBot.build(:user) }
  let(:admin_user) { FactoryBot.build(:admin_user) }

  permissions :index?, :show? do
    context '"self" user' do
      let(:policy_context) { described_class::Context.new(user, user) }
      let(:policy) { described_class.new(policy_context, nil) }

      it 'allows access' do
        expect(policy.index?).to eq(true)
      end

      it 'allows access' do
        expect(policy.show?).to eq(true)
      end
    end

    context 'admin user' do
      let(:policy_context) { described_class::Context.new(admin_user, user) }
      let(:policy) { described_class.new(policy_context, nil) }

      it 'allows access' do
        expect(policy.index?).to eq(true)
      end

      it 'allows access' do
        expect(policy.show?).to eq(true)
      end
    end

    context '*not* "self" user' do
      let(:policy_context) { described_class::Context.new(user, other_user) }
      let(:policy) { described_class.new(policy_context, nil) }

      it 'denies access' do
        expect(policy.index?).to eq(false)
      end

      it 'allows access' do
        expect(policy.show?).to eq(false)
      end
    end
  end

  permissions :create?, :destroy? do
    let(:language) { mock_model(Language, lang_code: 'en') }

    context '"self" user' do
      let(:policy_context) { described_class::Context.new(user, nil) }
      let(:policy) { described_class.new(policy_context, user_language) }
      let(:user_language) { mock_model(UserLanguage, user: user, language: language) }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end

      it 'allows access' do
        expect(policy.destroy?).to eq(true)
      end
    end

    context 'admin user' do
      let(:policy_context) { described_class::Context.new(admin_user, nil) }
      let(:policy) { described_class.new(policy_context, user_language) }
      let(:user_language) { mock_model(UserLanguage, user: user, language: language) }

      it 'allows access' do
        expect(policy.create?).to eq(true)
      end

      it 'allows access' do
        expect(policy.destroy?).to eq(true)
      end
    end

    context '*not* "self" user' do
      let(:policy_context) { described_class::Context.new(user, nil) }
      let(:policy) { described_class.new(policy_context, user_language) }
      let(:user_language) do
        mock_model(UserLanguage, user: other_user, language: language)
      end

      it 'denies access' do
        expect(policy.create?).to eq(false)
      end

      it 'allows access' do
        expect(policy.destroy?).to eq(false)
      end
    end
  end
end
