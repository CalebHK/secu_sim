require 'test_helper'

class InventoryTest < ActiveSupport::TestCase
  def setup
    @account = accounts(:one)
    # This code is not idiomatically correct.
    @inventory = @account.inventories.build(code: "APPL")
  end

  test "should be valid" do
    assert @account.valid?
  end

  test "account id should be present" do
    @inventory.account_id = nil
    assert_not @inventory.valid?
  end
  
  test "code should be present" do
    @inventory.code = "   "
    assert_not @inventory.valid?
  end

  test "code should be at most 6 characters" do
    @inventory.code = "a" * 7
    assert_not @inventory.valid?
  end
end
