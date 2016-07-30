defmodule Gibran.Mixfile do
  use Mix.Project

  def project do
    [app: :gibran,
     version: "0.0.4",
     elixir: "~> 1.0",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps,
     description: description,
     package: package,
     name: "Gibran",
     source_url: "https://github.com/abitdodgy/gibran",
     homepage_url: "https://github.com/abitdodgy/gibran",
     docs: docs]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  defp description do
    "An Elixir natural language processor."
  end

  defp package do
    [maintainers: ["Mohamad El-Husseini"],
     licenses: ["MIT"],
     links: %{github: "https://github.com/abitdodgy/gibran"}]
  end

  defp docs do
    [extras: ["README.md"]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:ex_doc, "~> 0.10", only: :dev},
     {:earmark, "~> 0.1", only: :dev}]
  end
end
