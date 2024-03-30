defmodule GenETS.MixProject do
  use Mix.Project

  def project do
    [
      app: :gen_ets,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      description: "Small wrapper around :ets Erlang/OTP library",
      package: [
        name: "gen_ets",
        licenses: ["Apache-2.0"],
        links: %{"GitHub" => "https://github.com/leroyspro/gen_ets"}
      ],
      name: "GenETS",
      source_url: "https://github.com/leroyspro/gen_ets",
      homepage_url: "https://github.com/leroyspro/gen_ets"
    ]
  end
end
