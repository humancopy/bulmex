defmodule Bulmex do
  @moduledoc ~S"""
  Documentation for Bulmex.
  """

  import Bulmex.Utility
  import Bulmex.Builder

  @doc ~S"""
  Creates a wrapper element with given content.

    iex> Phoenix.HTML.safe_to_string(bulma_wrapper do
    ...>   "Hello"
    ...> end)
    "<div class=\"field\">Hello</div>"

    iex> Phoenix.HTML.safe_to_string(bulma_wrapper(class: "is-grouped") do
    ...>   "Hello"
    ...> end)
    "<div class=\"is-grouped field\">Hello</div>"
  """
  @spec bulma_wrapper(Keyword.t) :: binary
  def bulma_wrapper(html_block) do
    bulma_wrapper([], html_block)
  end
  def bulma_wrapper(options, do: html_block) when is_list(options) do
    build_wrapper([wrapper: options], html_block)
  end

  @doc """
  Creates an input element.

    <%= bulma_input(Phoenix.HTML.Form, :first_name) %>
  """
  @spec bulma_input(Phoenix.HTML.Form.t, atom, Keyword.t) :: binary
  def bulma_input(form, field, options \\ []) do
    build_input(form, field, options)
  end

  @doc ~S"""
  Creates a button element.

    iex> Phoenix.HTML.safe_to_string(bulma_button("Hello"))
    "<div class=\"field\"><div class=\"control\"><button class=\"button\">Hello</button></div></div>"

    iex> Phoenix.HTML.safe_to_string(bulma_button("Hello", class: "is-danger"))
    "<div class=\"field\"><div class=\"control\"><button class=\"is-danger button\">Hello</button></div></div>"
  """
  @spec bulma_button(String.t, Keyword.t) :: binary
  def bulma_button(text, options \\ []) do
    build_button(text, options)
  end

  @doc ~S"""
  Creates a button element.

    iex> Phoenix.HTML.safe_to_string(bulma_submit("Hello"))
    "<div class=\"field\"><div class=\"control\"><button class=\"is-primary button\">Hello</button></div></div>"
  """
  @spec bulma_submit(String.t, Keyword.t) :: binary
  def bulma_submit(text, options \\ []) do
    build_button(text, options |> append_options(class: "is-primary"))
  end

  @doc ~S"""
  Creates a cancel link button element.

    iex> Phoenix.HTML.safe_to_string(bulma_cancel("Hello", "#back"))
    "<div class=\"field\"><div class=\"control\"><a class=\"is-text button\" href=\"#back\">Hello</a></div></div>"
  """
  @spec bulma_cancel(String.t, String.t, Keyword.t) :: binary
  def bulma_cancel(text, to, options \\ []) do
    build_link_button(text, to, options |> append_options(class: "is-text"))
  end

  @doc """
  Creates a form element.
  """
  @spec bulma_form_for(Phoenix.HTML.FormData.t(), String.t(), (Phoenix.HTML.Form.t -> Phoenix.HTML.unsafe())) ::
            Phoenix.HTML.safe()
  @spec bulma_form_for(Phoenix.HTML.FormData.t(), String.t(), Keyword.t(), (Phoenix.HTML.Form.t -> Phoenix.HTML.unsafe())) ::
          Phoenix.HTML.safe()
  def bulma_form_for(form_data, action, options \\ [], fun)
  def bulma_form_for(%{action: data_action} = form_data, action, options, fun) when is_function(fun, 1) and data_action !== nil do
    build_form form_data, action, options, fn f ->
      [
        build_errors(form_data),
        fun.(f)
      ]
    end
  end
  def bulma_form_for(form_data, action, options, fun) when is_function(fun, 1) do
    build_form(form_data, action, options, fun)
  end
end
