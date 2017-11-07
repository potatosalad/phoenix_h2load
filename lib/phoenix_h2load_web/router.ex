defmodule PhoenixH2loadWeb.Router do
  use PhoenixH2loadWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PhoenixH2loadWeb do
    pipe_through :api
  end
end
