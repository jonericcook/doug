defmodule Doug.Task do
  use Task

  def start_link(opts \\ []) do
    app_name = Keyword.fetch!(opts, :app_name)
    {args, _opts} = Keyword.pop(opts, :args, [])
    Task.start_link(Module.concat(app_name, __MODULE__), :run, args)
  end

  def run(args \\ []) do
    {polling_time_ms, _opts} = Keyword.pop(args, :polling_time_ms, 2_000)
    receive do
    after
      polling_time_ms ->
        {_current_value, updated_value} =
          Doug.State.get()
          |> Map.get_and_update(:counter, fn current_value ->
            case current_value do
              nil ->
                {current_value, 1}

              current_value ->
                {current_value, current_value + 1}
            end
          end)

        Doug.State.set(updated_value)
        run()
    end
  end
end
