defmodule PhoenixH2load.PlugHandler do
  @behaviour Plug

  case System.get_env("COWBOY_VERSION") do
    "1" <> _ ->
      def start_link() do
        Plug.Adapters.Cowboy.http(__MODULE__, [], [
          port: 29594
        ])
      end
    _ ->
      def start_link() do
        Plug.Adapters.Cowboy2.http(__MODULE__, [], [
          port: 29594
        ])
      end
  end

  @impl Plug
  def init(_opts) do
    nil
  end

  @impl Plug
  def call(conn, _opts) do
    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, "Hello world!")
  end
end