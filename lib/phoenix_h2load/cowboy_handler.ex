case System.get_env("COWBOY_VERSION") do
  "1" <> _ ->
    defmodule PhoenixH2load.CowboyHandler do
      def init(_transport, req, opts) do
        {:upgrade, :protocol, __MODULE__, req, opts}
      end

      def upgrade(req, env, __MODULE__, _opts) do
        {:ok, req} =
          :cowboy_req.reply(200, [
            {"content-type", "text/plain"}
          ], "Hello world!", req)
        {:ok, req, [{:result, :ok} | env]}
      end
    end
  _ ->
    defmodule PhoenixH2load.CowboyHandler do
      @behaviour :cowboy_handler

      @impl :cowboy_handler
      def init(req, opts) do
        req =
          :cowboy_req.reply(200, %{
            "content-type" => "text/plain"
          }, "Hello world!", req)
        {:ok, req, opts}
      end
    end
end