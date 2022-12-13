defmodule Doug.Runner do
  use GenServer

  def start_link(opts \\ []) do
    app_name = Keyword.fetch!(opts, :app_name)
    initial_state = Keyword.get(opts, :initial_state, %{}) |> Map.put(:app_name, app_name)
    GenServer.start_link(__MODULE__, initial_state, name: Module.concat(app_name, __MODULE__))
  end

  @impl true
  def init(state) do
    schedule_runner()
    {:ok, state}
  end

  @impl true
  def handle_info(:work, %{app_name: app_name} = state) do
    {_current_value, updated_state} =
      app_name
      |> Doug.State.get()
      |> Map.get_and_update(:be_kind, fn current_value ->
        case current_value do
          nil ->
            {current_value, false}

          true ->
            {current_value, false}

          false ->
            {current_value, true}
        end
      end)

    Doug.State.set(app_name, updated_state)
    schedule_runner()

    {:noreply, state}
  end

  defp schedule_runner do
    Process.send_after(self(), :work, 4_000)
  end
end
