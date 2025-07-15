defmodule StationServerWeb.Images.TodoController do
  use StationServerWeb, :controller

  alias StationServerWeb.AppModule

  def show(conn, _params) do
    assigns = %{
      links: AppModule.navigation_links(StationServerWeb.Modules.Todo)
    }

    conn
    |> render(assigns)
  end
end
