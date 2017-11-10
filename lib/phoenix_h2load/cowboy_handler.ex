case System.get_env("COWBOY_VERSION") do
  "1" <> _ ->
    defmodule PhoenixH2load.CowboyHandler do
      @behaviour :cowboy_http_handler

      @impl :cowboy_http_handler
      def init(_transport, req, opts) do
        {:ok, req, opts}
      end

      @impl :cowboy_http_handler
      def handle(req, state) do
        {:ok, req} =
          :cowboy_req.reply(200, [
            {"content-type", "text/plain"}
          ], "Hello world!", req)
        {:ok, req, state}
      end

      @impl :cowboy_http_handler
      def terminate(_reason, _req, _state) do
        :ok
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