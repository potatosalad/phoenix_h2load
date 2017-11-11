defmodule PhoenixH2load.AceHandler do
  use Raxx.Server

  @impl Raxx.Server
  def handle_request(_request, _opts) do
    Raxx.response(:ok)
    |> Raxx.set_header("content-type", "text/plain")
    |> Raxx.set_body("Hello world!")
  end

  @impl Raxx.Server
  def handle_tail(_headers, {request, body, state}) do
    handle_request(%{request | body: body}, state)
  end

end