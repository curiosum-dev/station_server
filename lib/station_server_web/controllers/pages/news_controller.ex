defmodule StationServerWeb.Pages.NewsController do
  use StationServerWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end
end
