defmodule Doug.State do
  use Agent

  def start_link(opts \\ []) do
    app_name = Keyword.fetch!(opts, :app_name)
    initial_state = Keyword.get(opts, :initial_state, %{})
    Agent.start_link(fn -> initial_state end, name: Module.concat(app_name, __MODULE__))
  end

  def get(app_name), do: Agent.get(Module.concat(app_name, __MODULE__), & &1)

  def set(app_name, new_state),
    do: Agent.update(Module.concat(app_name, __MODULE__), fn _current_state -> new_state end)
end
