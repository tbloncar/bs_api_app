require_relative '../../lib/budget_simple_api'

describe BudgetSimpleAPI do
  let(:api) { BudgetSimpleAPI.new("travis@example.com", "password") }

  it 'should be instantiated with an email and password' do
    expect(api.class).to eq(BudgetSimpleAPI)
  end
end

