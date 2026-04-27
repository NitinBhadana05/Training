require "test_helper"

class BillsControllerTest < ActionDispatch::IntegrationTest
  test "shows bills for signed in user" do
    sign_in_as(users(:one))

    get bills_url
    assert_response :success

    get bill_url(bills(:one))
    assert_response :success
  end

  test "blocks access to another users bill" do
    sign_in_as(users(:one))

    get bill_url(bills(:two))
    assert_redirected_to bills_path
  end

  test "allows admin to update bill status" do
    sign_in_as(users(:admin))

    patch bill_url(bills(:one)), params: { bill: { status: "paid" } }

    assert_redirected_to bill_path(bills(:one))
    assert_equal "paid", bills(:one).reload.status
  end
end
