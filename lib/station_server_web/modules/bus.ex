defmodule StationServerWeb.Modules.Bus do
  @behaviour StationServerWeb.AppModule

  @impl true
  def name, do: "Tram&Bus"

  @impl true
  def path, do: "/bus"

  @impl true
  def page_data do
    %{
      refresh_every: 30_000
    }
  end
end
