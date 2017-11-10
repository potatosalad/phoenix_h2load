defmodule PhoenixH2loadWeb.Router do
  use PhoenixH2loadWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixH2loadWeb do
    pipe_through :api

    get "/", HelloController, :get
  end
end
