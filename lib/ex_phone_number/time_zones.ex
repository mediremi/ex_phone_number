defmodule ExPhoneNumber.TimeZones do
  @moduledoc false

  # libphonenumber's prefix-to-time-zones table, as PhoneNumberToTimeZonesMapper
  # uses it. Each line is a prefix (the country code followed by the start of
  # the national significant number), then the time zones of the numbers that
  # start with it, separated by "&". The time zones are CLDR's canonical IDs,
  # some of which are links in the IANA database (e.g. "Asia/Calcutta").

  alias ExPhoneNumber.Model.PhoneNumber

  @unknown_time_zones ["Etc/Unknown"]

  @map_data_path Path.join(["resources", "timezones", "map_data.txt"])
  @external_resource @map_data_path

  prefix_to_time_zones =
    @map_data_path
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.reject(&String.starts_with?(&1, "#"))
    |> Map.new(fn line ->
      [prefix, time_zones] = String.split(line, "|")
      {prefix, String.split(time_zones, "&")}
    end)

  @longest_prefix prefix_to_time_zones |> Map.keys() |> Enum.map(&byte_size/1) |> Enum.max()

  defp prefix_to_time_zones_map() do
    unquote(Macro.escape(prefix_to_time_zones))
  end

  # As libphonenumber's PrefixTimeZonesMap, this looks up the longest prefix of
  # the country code and national significant number, whatever the number's
  # type, so a number that isn't valid gets the time zones of the longest
  # prefix it starts with (often its country's).
  def get_time_zones_for_number(%PhoneNumber{country_code: country_code} = phone_number) when is_integer(country_code) do
    key = Integer.to_string(country_code) <> PhoneNumber.get_national_significant_number(phone_number)

    key
    |> binary_part(0, min(byte_size(key), @longest_prefix))
    |> lookup()
  end

  defp lookup(""), do: @unknown_time_zones

  defp lookup(prefix) do
    case prefix_to_time_zones_map() do
      %{^prefix => time_zones} -> time_zones
      %{} -> prefix |> binary_part(0, byte_size(prefix) - 1) |> lookup()
    end
  end
end
