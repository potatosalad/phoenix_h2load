defmodule PhoenixH2load.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      worker(PhoenixH2load.SchedulerUtilization, []),
      event_manager(),
      cowboy_server(),
      worker(PhoenixH2load.PlugHandler, []),
      # Start the endpoint when the application starts
      supervisor(PhoenixH2loadWeb.Endpoint, []),
      # Start your own worker by calling: PhoenixH2load.Worker.start_link(arg1, arg2, arg3)
      # worker(PhoenixH2load.Worker, [arg1, arg2, arg3]),
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PhoenixH2load.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PhoenixH2loadWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  @doc false
  defp event_manager() do
    local_name = :phoenix_h2load_event.manager()
    {
      local_name,
      {:gen_event, :start_link, [{:local, local_name}]},
      :permanent, 5000, :worker, [:gen_event]
    }
  end

  case System.get_env("COWBOY_VERSION") do
    "1" <> _ ->
      defp cowboy_server() do
        dispatch = :cowboy_router.compile([{:_, [{:_, PhoenixH2load.CowboyHandler, []}]}])
        ref = PhoenixH2load.CowboyHandler.HTTP
        transport_options = [
          port: 29593
        ]
        protocol_options = [
          env: [ dispatch: dispatch ]
        ]
        {
          {:ranch_listener_sup, ref},
          {:cowboy, :start_http, [
            ref, 100, transport_options, protocol_options
          ]},
          :permanent, :infinity, :supervisor, [:ranch_listener_sup]
        }
      end
    _ ->
      defp cowboy_server() do
        dispatch = :cowboy_router.compile([{:_, [{:_, PhoenixH2load.CowboyHandler, []}]}])
        ref = PhoenixH2load.CowboyHandler.HTTP
        transport_options = [
          port: 29593
        ]
        protocol_options = %{
          env: %{ dispatch: dispatch }
        }
        {
          {:ranch_listener_sup, ref},
          {:cowboy, :start_clear, [
            ref, transport_options, protocol_options
          ]},
          :permanent, :infinity, :supervisor, [:ranch_listener_sup]
        }
      end
  end
end
