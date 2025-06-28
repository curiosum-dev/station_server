defmodule StationServerWeb.PageController do
  use StationServerWeb, :controller

  def index(conn, _params) do
    render(conn, :index)
  end

  def bus(conn, _params) do
    render(conn, :bus)
  end

  def news(conn, _params) do
    render(conn, :news)
  end
end
