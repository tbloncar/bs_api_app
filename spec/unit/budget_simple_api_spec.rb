require_relative '../../lib/budget_simple_api'

describe BudgetSimple::API do
  let(:api) { BudgetSimple::API.new(email: "travis@example.com", password: "password") }

  it 'should be instantiated with an email and password' do
    expect(api.class).to eq(BudgetSimple::API)
  end
end

