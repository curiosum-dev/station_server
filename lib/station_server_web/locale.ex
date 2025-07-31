defmodule StationServerWeb.Locale do
  @moduledoc """
  Handles locale configuration and switching for internationalization.
  """

  @doc """
  Gets the current configured locale from application environment.
  Defaults to "en" if not configured.
  """
  def get_locale do
    Application.get_env(:station_server, :language, "en")
  end

  @doc """
  Sets the current locale for gettext.
  """
  def set_locale(locale) when locale in ["en", "pl"] do
    Gettext.put_locale(StationServerWeb.Gettext, locale)
    Application.put_env(:station_server, :language, locale)
    :ok
  end

  def set_locale(_), do: {:error, :invalid_locale}

  @doc """
  Initializes the locale from configuration.
  Should be called during application startup.
  """
  def init_locale do
    locale = get_locale()
    set_locale(locale)
  end
end
