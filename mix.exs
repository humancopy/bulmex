defmodule Bulmex.MixProject do
  use Mix.Project

  def project do
    [
      app: :bulmex,
      version: "0.1.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_html, "~> 2.11"},

      {:gettext, ">= 0.0.0", only: :test},

      {:ex_doc, ">= 0.0.0", only: :docs}
    ]
  end
end
