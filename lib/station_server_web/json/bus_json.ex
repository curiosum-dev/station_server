defmodule StationServerWeb.Pages.BusJSON do
  alias StationServerWeb.AppModule

  def index(_params \\ %{}) do
    AppModule.payload(StationServerWeb.Modules.Bus)
  end
end
