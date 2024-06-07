require "test_helper"

class Public::RelationshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get public_relationships_index_url
    assert_response :success
  end
end
