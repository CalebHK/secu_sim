require 'test_helper'

class AccountsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @account = accounts(:four)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Account.count' do
      post accounts_path, params: { account: { name: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Account.count' do
      delete account_path(@account)
    end
    assert_redirected_to login_url
  end
end
