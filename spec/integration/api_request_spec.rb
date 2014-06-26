require_relative '../../lib/budget_simple_api'

describe 'API communication' do
  let(:api) { BudgetSimpleAPI.new(email: "travis@example.com", password: "password") }

  it 'should authenticate' do
    expect(api.token).not_to eq(nil)
    expect(api.secret).not_to eq(nil)
  end

  it 'should validate authentication' do
    expect(api.validate["status"]).to eq(true)
  end

  context 'for the current period' do
    it 'should get a budget summary' do
      expect(api.budget_summary["totalSpent"]).to be >= 0
    end

    it 'should get a full budget' do
      expect(api.full_budget.count).to be >= 0
    end

    it 'should get budgeted items' do
      expect(api.budgeted.count).to be >= 0
    end

    it 'should get unbudgeted items' do
      expect(api.unbudgeted.count).to be >= 0
    end
  end
end
