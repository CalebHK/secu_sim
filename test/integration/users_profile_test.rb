require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:calebhk)
  end
  
  test "profile display" do
    log_in_as (@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.accounts.count.to_s, response.body
    @user.accounts.each do |account|
      assert_match account.name, response.body
      assert_match account.cash.to_s, response.body
      assert_match account.asset.to_s, response.body
    end
  end
end
