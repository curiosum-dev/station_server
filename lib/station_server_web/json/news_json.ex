defmodule StationServerWeb.Pages.NewsJSON do
  alias StationServerWeb.AppModule

  def index(_params \\ %{}) do
    AppModule.payload(StationServerWeb.Modules.News)
  end
end
