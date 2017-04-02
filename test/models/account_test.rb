require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:calebhk)
    @account = @user.accounts.build(name: "Stock_1", cash: 200.01)
  end

  test "should be valid" do
    assert @account.valid?
  end

  test "user id should be present" do
    @account.user_id = nil
    assert_not @account.valid?
  end
  
  test "name should be present" do
    @account.name = "   "
    assert_not @account.valid?
  end

  test "name should be at most 140 characters" do
    @account.name = "a" * 141
    assert_not @account.valid?
  end
  
  test "order should be most recent first" do
    assert_equal accounts(:five), Account.first
  end
end
