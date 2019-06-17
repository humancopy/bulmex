defmodule Bulmex.ConfigTest do
  use ExUnit.Case, async: true

  alias Bulmex.Config

  test "gets the config" do
    assert Config.get(:translation_module) == Bulmex.Gettext
  end

  test "throws an error on missing config" do
    try do
      Config.get(:non_existent_config)
    rescue
      e in Config.ConfigError -> assert e.message == "  Missing configuration for Bulmex. Add something like this to your config/config.ex\n  config :bulmex, non_existent_config: configuration_value\n"
    end
  end
end
