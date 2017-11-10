defmodule PhoenixH2load.Mixfile do
  use Mix.Project

  def project do
    [
      app: :phoenix_h2load,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      lockfile: lockfile()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {PhoenixH2load.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    cowboy_version =
      case System.get_env("COWBOY_VERSION") do
        "1" <> _ -> {:cowboy, "~> 1.0"}
        _ -> {:cowboy, github: "ninenines/cowboy", override: true}
      end
    [
      cowboy_version,
      {:phoenix, github: "phoenixframework/phoenix", branch: "gr-cowboy2", override: true},
      {:phoenix_pubsub, "~> 1.0"},
      {:gettext, "~> 0.13"}
    ]
  end

  defp lockfile() do
    case System.get_env("COWBOY_VERSION") do
      "1" <> _ -> "mix-cowboy1.lock"
      _ -> "mix.lock"
    end
  end
end
