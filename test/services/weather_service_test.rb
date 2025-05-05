# frozen_string_literal: true

require "test_helper"

class WeatherServiceTest < ActiveSupport::TestCase
  setup do
    # Do nothing
  end

  teardown do
    # Do nothing
  end

  test "returns a client" do
    assert_not_nil WeatherService.client
    assert_instance_of WeatherService::Client, WeatherService.client
  end
end
