defmodule Helloplug.Mixfile do
  use Mix.Project

  def project do
    [app: :helloplug,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  defp deps do
    [{:cowboy, "~> 1.0.0"},
     {:plug, "~> 1.0"},
     {:sqlite_ecto, "~> 1.0.0"},
     {:ecto, "~> 1.0"}]
  end
  def application do
    [applications: [:logger, :sqlite_ecto, :ecto, :cowboy, :plug]]
    [extra_applications: [:logger]]
  end
end
