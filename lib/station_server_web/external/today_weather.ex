defmodule StationServerWeb.External.TodayWeather do
  @openweather_api_key Application.compile_env(:station_server, :openweather_api_key)

  def get_today_weather_data do
    payload =
      Req.get!(
        "https://api.openweathermap.org/data/2.5/forecast?q=Poznan,PL&units=metric&lang=pl&appid=#{@openweather_api_key}"
      ).body

    date_time = NaiveDateTime.local_now()
    date = date_time |> NaiveDateTime.to_date()
    dtplus9 = date_time |> NaiveDateTime.add(9, :hour)

    # Find items for dt_txt that are between date_time inclusive and dtplus9 exclusive
    today =
      payload["list"]
      |> Stream.filter(fn item ->
        NaiveDateTime.compare(NaiveDateTime.from_iso8601!(item["dt_txt"]), date_time) == :gt and
          NaiveDateTime.compare(NaiveDateTime.from_iso8601!(item["dt_txt"]), dtplus9) == :lt
      end)
      |> Enum.map(fn item ->
        %{
          temperature: item["main"]["temp"] |> round(),
          time: NaiveDateTime.from_iso8601!(item["dt_txt"]) |> Calendar.strftime("%H:%M"),
          icon: item["weather"] |> hd() |> Map.get("icon")
        }
      end)

    date_plus_4 = date |> Date.add(4)

    next_days =
      payload["list"]
      |> Stream.filter(fn item ->
        item_date = NaiveDateTime.from_iso8601!(item["dt_txt"]) |> NaiveDateTime.to_date()
        Date.compare(item_date, date) == :gt and Date.compare(item_date, date_plus_4) == :lt
      end)
      |> Enum.group_by(&(NaiveDateTime.from_iso8601!(&1["dt_txt"]) |> NaiveDateTime.to_date()))
      |> Enum.map(fn {date, items} ->
        min_temp_item =
          items
          |> Enum.min_by(fn item -> get_in(item, ["main", "temp"]) end)

        max_temp_item =
          items
          |> Enum.max_by(fn item -> get_in(item, ["main", "temp"]) end)

        min_temp = min_temp_item |> get_in(["main", "temp"])
        max_temp = max_temp_item |> get_in(["main", "temp"])

        icon = min_temp_item["weather"] |> hd() |> Map.get("icon")

        %{
          day_of_week: date |> Date.day_of_week() |> day_of_week_caption(),
          min_temp: min_temp |> round(),
          max_temp: max_temp |> round(),
          icon: icon
        }
      end)

    %{today: today, next_days: next_days}
  end

  defp day_of_week_caption(1), do: "PN"
  defp day_of_week_caption(2), do: "WT"
  defp day_of_week_caption(3), do: "ŚR"
  defp day_of_week_caption(4), do: "CZW"
  defp day_of_week_caption(5), do: "PT"
  defp day_of_week_caption(6), do: "SB"
  defp day_of_week_caption(7), do: "ND"
end
