defmodule StationServerWeb.Modules.News do
  @behaviour StationServerWeb.AppModule

  @impl true
  def name, do: "News"

  @impl true
  def path, do: "/news"

  @impl true
  def image_path(_assigns), do: "/images/news.png"

  @impl true
  def page_data do
    %{
      refresh_every: 30_000
    }
  end

  @impl true
  def extra_links(_params) do
    %{}
  end
end
