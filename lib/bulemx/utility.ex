defmodule Bulmex.Utility do
  @moduledoc ~S"""
  Utility helpers
  """

  @doc ~S"""
  A helper to append options to a keyword

    iex> append_options([class: "button"], nil)
    [class: "button"]

    iex> append_options([class: "button"], class: "is-primary")
    [class: "button is-primary"]
  """
  @spec append_options(List.t, nil | List.t) :: List.t
  def append_options(opts, nil), do: opts
  def append_options(opts, extra_opts), do: Keyword.merge(opts, extra_opts, &concat_options/3)

  @doc ~S"""
  A helper to concat options

    iex> concat_options(:key, "button", "is-primary")
    "button is-primary"

    iex> concat_options(:key, ["button"], ["is-primary"])
    ["button", "is-primary"]

    iex> concat_options(:key, %{name: "button"}, %{age: 20})
    %{name: "button", age: 20}
  """
  @spec concat_options(atom, String.t | List.t | Map.t, String.t | List.t | Map.t) :: String.t | List.t | Map.t
  def concat_options(_key, v1, v2) when is_binary(v1), do: "#{v1} #{v2}"
  def concat_options(_key, v1, v2) when is_list(v1),   do: Enum.concat(v1, v2)
  def concat_options(_key, v1, v2) when is_map(v1),    do: Map.merge(v1, v2)
end