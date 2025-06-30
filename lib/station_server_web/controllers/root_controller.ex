defmodule StationServerWeb.RootController do
  use StationServerWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/weather")
  end
end
