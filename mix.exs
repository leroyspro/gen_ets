defmodule GenETS.MixProject do
  use Mix.Project

  def project do
    [
      app: :gen_ets,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
    ]
  end
end
