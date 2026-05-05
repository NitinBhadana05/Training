require "test_helper"

class LegendsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @legend = legends(:one)
  end

  test "should get index" do
    get legends_url
    assert_response :success
  end

  test "should get show" do
    get legend_url(@legend)
    assert_response :success
  end

  test "should get new" do
    get new_legend_url
    assert_response :success
  end

  test "should get edit" do
    get edit_legend_url(@legend)
    assert_response :success
  end

  test "should create legend" do
    assert_difference("Legend.count", 1) do
      post legends_url, params: {
        legend: {
          title: "Ghost Train",
          description: "A report of a train seen at night with no tracks left behind in daylight.",
          location: "Kolkata",
          credibility_score: 5
        }
      }
    end

    assert_redirected_to legend_url(Legend.order(:created_at).last)
  end

  test "should update legend" do
    patch legend_url(@legend), params: {
      legend: {
        title: "Updated Legend",
        description: "An updated version of the tale with enough detail to satisfy validation.",
        location: "Pune",
        credibility_score: 8
      }
    }

    assert_redirected_to legend_url(@legend)
  end

  test "should destroy legend" do
    assert_difference("Legend.count", -1) do
      delete legend_url(@legend)
    end

    assert_redirected_to legends_url
  end

  test "should reject invalid create" do
    assert_no_difference("Legend.count") do
      post legends_url, params: {
        legend: {
          title: "",
          description: "short",
          location: "Nowhere",
          credibility_score: 99
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should reject invalid update" do
    patch legend_url(@legend), params: {
      legend: {
        title: "",
        description: "tiny",
        location: "Pune",
        credibility_score: 0
      }
    }

    assert_response :unprocessable_entity
  end
end
