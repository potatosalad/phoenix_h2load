defmodule PhoenixH2loadWeb.HelloController do
  use PhoenixH2loadWeb, :controller

  def get(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "Hello world!")
  end
end
