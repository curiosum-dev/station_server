defmodule StationServerWeb.External.Transit.Departures do
  @moduledoc """
  Module for fetching transit departures using MOTIS API
  """

  @motis_base_url "https://api.transitous.org/api/v1"

  @doc """
  Get departures for a specific stop using MOTIS API

  ## Parameters
  - stop_id: The MOTIS stop ID (e.g., "pl-Poznań_456")
  - limit: Number of departures to fetch (default: 10)

  ## Returns
  Grouped departures by {route_id, headsign} with departure times and realtime indicators
  """
  def get_departures(stop_id, limit \\ 10) do
    with {:ok, response} <- fetch_motis_departures(stop_id, limit),
         {:ok, grouped_data} <- group_departures(response) do
      {:ok, grouped_data}
    else
      {:error, reason} -> {:error, reason}
    end
  end

  @doc """
  Fetch raw departures from MOTIS API
  """
  def fetch_motis_departures(stop_id, limit) do
    url = "#{@motis_base_url}/stoptimes"

    params = %{
      "stopId" => stop_id,
      "n" => limit
    }

    case Req.get(url, params: params) do
      {:ok, %{status: 200, body: body}} ->
        {:ok, body}

      {:ok, %{status: status}} ->
        {:error, "API returned status #{status}"}

      {:error, reason} ->
        {:error, "Request failed: #{reason}"}
    end
  end

  @doc """
  Group departures by {route_id, headsign} and extract departure times with realtime indicators
  """
  def group_departures(response) do
    grouped =
      response["stopTimes"]
      |> Enum.group_by(fn stop_time ->
        # Group by route and headsign
        {stop_time["routeShortName"], stop_time["headsign"]}
      end)
      |> Enum.map(fn {{route_id, headsign}, departures} ->
        departure_list =
          departures
          |> Enum.map(fn departure ->
            %{
              departure_time: departure["place"]["departure"],
              scheduled_time: departure["place"]["scheduledDeparture"],
              is_realtime: departure["realTime"],
              delay_minutes:
                calculate_delay(
                  departure["place"]["departure"],
                  departure["place"]["scheduledDeparture"]
                ),
              mode: departure["mode"],
              cancelled: departure["cancelled"]
            }
          end)
          |> Enum.sort_by(& &1.departure_time)

        %{
          route_id: route_id,
          headsign: headsign,
          departures: departure_list,
          total_departures: length(departure_list),
          realtime_departures: Enum.count(departure_list, & &1.is_realtime)
        }
      end)
      |> Enum.sort_by(&first_departure_time/1)

    {:ok, grouped}
  end

  defp first_departure_time(routes) do
    routes[:departures]
    |> hd()
    |> Map.get(:departure_time)
    |> NaiveDateTime.from_iso8601!()
  end

  # Calculate delay in minutes between actual and scheduled departure
  # Returns positive number for delays, negative for early departures
  defp calculate_delay(actual_time, scheduled_time) do
    with {:ok, actual_dt} <- DateTime.from_iso8601(actual_time),
         {:ok, scheduled_dt} <- DateTime.from_iso8601(scheduled_time) do
      DateTime.diff(actual_dt, scheduled_dt, :second) |> div(60)
    else
      _ -> nil
    end
  end
end
