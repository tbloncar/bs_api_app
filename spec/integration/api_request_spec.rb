require_relative '../../lib/budget_simple_api'

describe "API communication" do
  let(:api) { BudgetSimpleAPI.new("travis@example.com", "password") }

  it 'should authenticate' do
    expect(api.token).not_to eq(nil)
    expect(api.secret).not_to eq(nil)
  end

  it 'should validate authentication' do
    expect(api.validate["status"]).to eq(true)
  end

  it 'should get a budget summary' do
    expect(api.budget_summary["totalSpent"]).to be >= 0
  end
end
