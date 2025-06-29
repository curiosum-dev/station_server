defmodule StationServerWeb.Pages.BusController do
  use StationServerWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
