use Mix.Config

config :bulmex,
  translation_module: Bulmex.Gettext

config :gettext, Bulmex.Gettext, priv: "test/priv/gettext"