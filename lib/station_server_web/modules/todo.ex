defmodule StationServerWeb.Modules.Todo do
  use StationServerWeb.AppModule

  @impl true
  def name, do: "Todo"

  @impl true
  def path, do: "/todo"

  @impl true
  def image_path(_assigns), do: "/images/todo.png"

  @impl true
  def page_data do
    %{
      refresh_every: 30_000
    }
  end
end
