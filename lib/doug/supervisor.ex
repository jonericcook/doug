defmodule Doug.Supervisor do
  use Supervisor

  def start_link(opts \\ []) do
    app_name = Keyword.fetch!(opts, :app_name)
    Supervisor.start_link(__MODULE__, opts, name: Module.concat(app_name, __MODULE__))
  end

  @impl true
  def init(opts) do
    state_opts = Keyword.take(opts, [:state_opts, :app_name])
    runner_opts = Keyword.take(opts, [:runner_opts, :app_name])

    children = [
      {Doug.State, state_opts},
      {Doug.Runner, runner_opts}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
