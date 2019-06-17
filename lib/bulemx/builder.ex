defmodule Bulmex.Builder do
  @moduledoc """
  Methods for building Bulma inputs, labels, wrappers & buttons.
  """
  alias Bulmex.ErrorHelpers
  import Bulmex.Utility
  use Phoenix.HTML

  @doc """
  The button tag builder.
  """
  @spec build_button(String.t, Keyword.t) :: binary
  def build_button(text, opts \\ []) do
    button_opts = opts
    |> Keyword.delete(:wrapper)
    |> append_options(class: "button")

    build_wrapper(opts) do
      content_tag :div, class: "control" do
        content_tag(:button, text, button_opts)
      end
    end
  end

  @doc """
  The input tag builder.
  """
  @spec build_input(Phoenix.HTML.Form.t, atom, Keyword.t) :: binary
  def build_input(form, field, opts \\ []) do
    build_wrapper(opts) do
      [
        build_label(form, field, opts),
        build_control(form, field, opts)
      ]
    end
  end

  @doc """
  The label tag builder.
  """
  @spec build_label(Phoenix.HTML.Form.t, atom, Keyword.t) :: binary
  def build_label(form, field, opts) do
    label(form, field, humanize(field), label_opts(opts))
  end
  defp label_opts(opts) do
    opts
    |> Keyword.get(:label, [])
    |> append_options(class: "label")
  end

  @doc """
  The wrapper builder.
  """
  # @spec build_wrapper(Keyword.t, Function.t) :: binary
  def build_wrapper(do: html_block) do
    build_wrapper([], html_block)
  end
  def build_wrapper(opts, do: html_block) when is_list(opts) do
    build_wrapper(opts, html_block)
  end
  def build_wrapper(opts, html_block) do
    case opts[:wrapper] do
      false -> html_block
      _     -> content_tag(:div, html_block, wrapper_opts(opts))
    end
  end
  defp wrapper_opts(opts) do
    opts
    |> Keyword.get(:wrapper, [])
    |> append_options(class: "field")
  end

  def build_errors(_form_data) do
    content_tag(:div, class: "notification is-danger") do
      [
        content_tag(:button, "", class: "delete"),
        "Oops, something went wrong! Please check the errors below."
      ]
    end
  end

  def build_form(form_data, action, options, fun) do
    form_for(form_data, action, options, fun)
  end

  defp build_control(form, field, opts) do
    type = guess_input_type(form, field, opts[:as])

    input_opts =
      opts
      |> Keyword.delete(:as)
      |> Keyword.delete(:wrapper)
      |> Keyword.delete(:label)
      |> append_options(class: "#{input_class(type)} #{state_class(form, field)}")
      |> append_validations(form, field)

    content_tag :div, class: "control" do
      input = input(type, form, field, input_opts)
      error = ErrorHelpers.error_tag(form, field) || ""

      [input, error]
    end
  end

  defp input(:select, form, field, input_opts) do
    content_tag :div, class: "select" do
      apply(Phoenix.HTML.Form, :select, [form, field, input_opts[:options], Keyword.delete(input_opts, :options)])
    end
  end

  defp input(type, form, field, input_opts) do
    apply(Phoenix.HTML.Form, type, [form, field, input_opts])
  end

  defp state_class(form, field) do
    cond do
      # The form was not yet submitted
      !form.source.action -> ""
      form.errors[field]  -> "is-danger"
      true -> "is-success"
    end
  end

  defp append_validations(opts, form, field) do
    # Let's get the validations ...
    Phoenix.HTML.Form.input_validations(form, field)
    |> Keyword.merge(opts)
  end

  defp input_class(:text_input), do: "input"
  defp input_class(:password_input), do: "input"
  defp input_class(:email_input), do: "input"
  defp input_class(type), do: type

  # Tries to guess the type of the input. For any input which has the password string in it
  # we assume a password field, unless the options[:as] has been supplied
  @spec guess_input_type(Phoenix.HTML.Form.t, atom, atom | nil) :: atom
  defp guess_input_type(form, field, nil) do
    if Regex.match?(~r/\bpassword\b/, Atom.to_string(field)) do
      :password_input
    else
      input_type(form, field)
    end
  end
  defp guess_input_type(_form, _field, as), do: as
end
