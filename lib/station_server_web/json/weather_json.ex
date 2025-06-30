defmodule StationServerWeb.Pages.WeatherJSON do
  alias StationServerWeb.AppModule

  def index(_params \\ %{}) do
    AppModule.payload(StationServerWeb.Modules.Weather)
  end
end
