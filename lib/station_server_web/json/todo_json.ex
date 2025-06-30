defmodule StationServerWeb.Pages.TodoJSON do
  alias StationServerWeb.AppModule

  def index(_params \\ %{}) do
    AppModule.payload(StationServerWeb.Modules.Todo)
  end
end
