defmodule Doug do
  def on?(app_name, feature_flag) do
    app_name
    |> Doug.State.get()
    |> Map.get(feature_flag, false)
  end
end
