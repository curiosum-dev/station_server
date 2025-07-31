defmodule StationServerWeb.Plugs.LocalePlug do
  @moduledoc """
  Plug to set the locale for each request based on application configuration.
  """

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    locale = StationServerWeb.Locale.get_locale()
    Gettext.put_locale(StationServerWeb.Gettext, locale)
    assign(conn, :locale, locale)
  end
end
