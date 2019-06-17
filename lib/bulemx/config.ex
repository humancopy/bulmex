defmodule Bulmex.Config do
  @moduledoc """
  Methods to access the configuration
  """

  defmodule ConfigError do
    defexception [:message]

    @impl true
    def exception(message: :translation_module) do
      %ConfigError{message: """
        Missing translation_module config. Add the following to your config/config.ex
        config :bulmex, translation_module: YourAppName.Gettext
      """}
    end
    def exception(message: key) do
      %ConfigError{message: """
        Missing configuration for Bulmex. Add something like this to your config/config.ex
        config :bulmex, #{key}: configuration_value
      """}
    end
  end

  @doc """
  Get the config value for key
  """
  @spec get(binary) :: binary
  def get(key) do
    Application.get_env(:bulmex, key) || raise_error(key)
  end

  @doc """
  Raise a ConfigError exception.
  """
  @spec raise_error(atom) :: no_return
  def raise_error(key) do
    raise ConfigError, message: key
  end
end