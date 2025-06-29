defmodule StationServerWeb.Images.TodoController do
  use StationServerWeb, :controller

  import StationServerWeb.Links

  def show(conn, _params) do
    assigns = %{
      links: links("/todo")
    }

    conn
    |> render(assigns)
  end
end
