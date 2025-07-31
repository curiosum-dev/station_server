defmodule StationServerWeb.Router do
  use StationServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug StationServerWeb.Plugs.LocalePlug
  end

  pipeline :image do
    plug :accepts, ["png", "image/*"]
    plug StationServerWeb.Plugs.LocalePlug
  end

  get "/", StationServerWeb.RootController, :index

  scope "/", StationServerWeb.Pages do
    pipe_through :api

    get "/weather", WeatherController, :index
    get "/bus", BusController, :index
    get "/news", NewsController, :index
    get "/todo", TodoController, :index
  end

  scope "/images", StationServerWeb.Images do
    pipe_through :image

    get "/weather.png", WeatherController, :show
    get "/bus.png", BusController, :show
    get "/news.png", NewsController, :show
    get "/todo.png", TodoController, :show
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:station_server, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: StationServerWeb.Telemetry
    end
  end
end
