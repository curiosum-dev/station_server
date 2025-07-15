defmodule StationServerWeb.Pages.BusJSON do
  alias StationServerWeb.AppModule

  def index(assigns \\ %{}) do
    AppModule.payload(StationServerWeb.Modules.Bus, assigns)
  end
end
