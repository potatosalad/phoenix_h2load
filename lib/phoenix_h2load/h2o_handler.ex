case System.get_env("H2O_VERSION") do
  "2" <> _ ->
    defmodule PhoenixH2load.H2OHandler do
      def call(_event, _opts) do
        {200, %{
          "content-length" => 12,
          "content-type" => "text/plain"
        }, "Hello world!"}
      end
    end
  _ ->
    defmodule PhoenixH2load.H2OHandler do
    end
end