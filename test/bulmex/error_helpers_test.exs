defmodule Bulmex.ErrorHelpersTest do
  use ExUnit.Case, async: true

  alias Bulmex.ErrorHelpers

  test "gets the config" do
    form = %Phoenix.HTML.Form{
      errors: [
        {:password, {"should be at least %{count} character(s)", [count: 10, validation: :length, kind: :min, type: :string]}}
      ]
    }
    error_msg =
      form
      |> ErrorHelpers.error_tag(:password)
      |> Phoenix.HTML.html_escape
      |> Phoenix.HTML.safe_to_string

    assert error_msg == "<span class=\"help is-danger tag\">should be at least 10 character(s)</span>"
  end
end
