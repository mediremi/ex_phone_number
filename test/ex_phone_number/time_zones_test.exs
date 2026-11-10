defmodule ExPhoneNumber.TimeZonesTest do
  use ExSpec, async: true

  alias ExPhoneNumber.Model.PhoneNumber

  # Unlike the metadata, the time zones table is the real one in every
  # environment, so these examples are what libphonenumber v9.0.41 gives.
  # Those from libphonenumber's PhoneNumberToTimeZonesMapperTest are the ones
  # that hold against the real table rather than its testing data.

  defp time_zones(country_code, national_number, fields \\ []) do
    PhoneNumber
    |> struct!([country_code: country_code, national_number: national_number] ++ fields)
    |> ExPhoneNumber.get_time_zones_for_number()
  end

  describe ".get_time_zones_for_number/1" do
    context "examples from libphonenumber" do
      it "returns the time zone of an Australian number" do
        assert ["Australia/Sydney"] == time_zones(61, 236_618_300)
      end

      it "returns the time zone of a Korean number" do
        assert ["Asia/Seoul"] == time_zones(82, 22_123_456)
      end

      it "returns the time zones of US numbers" do
        assert ["America/Los_Angeles"] == time_zones(1, 6_509_600_000)
        assert ["America/New_York"] == time_zones(1, 2_128_120_000)
      end

      it "returns Etc/Unknown for a country code that doesn't exist" do
        assert ["Etc/Unknown"] == time_zones(999, 2_423_651_234)
      end

      it "returns Etc/Unknown for a non-geographical number" do
        assert ["Etc/Unknown"] == time_zones(800, 12_345_678)
      end
    end

    context "numbers in Mexico" do
      it "returns the time zone of a number's area" do
        assert ["America/Tijuana"] == time_zones(52, 6_641_234_567)
        assert ["America/Cancun"] == time_zones(52, 9_981_234_567)
        assert ["America/Mazatlan"] == time_zones(52, 6_621_234_567)
      end

      it "returns the time zone of a shorter prefix when there's no line for the area" do
        assert ["America/Mexico_City"] == time_zones(52, 5_512_345_678)
      end
    end

    context "prefixes with several time zones" do
      it "returns all of them" do
        assert ["America/Boise", "America/Los_Angeles"] == time_zones(1, 2_082_000_000)
      end

      it "returns the country's time zones when only the country code matches" do
        # 52 isn't one of Brazil's area codes
        assert ["America/Manaus", "America/Noronha", "America/Rio_Branco", "America/Sao_Paulo"] ==
                 time_zones(55, 5_212_345_678)
      end
    end

    context "numbers that aren't valid" do
      # Unlike libphonenumber's getTimeZonesForNumber, but like its
      # getTimeZonesForGeographicalNumber, the number's type isn't checked.
      it "returns the time zones of the longest prefix that matches" do
        assert ["Asia/Seoul"] == time_zones(82, 1234)
        assert 42 == length(time_zones(1, 123_456_789))
      end
    end

    context "numbers with an Italian leading zero" do
      it "looks up the zeros too" do
        assert ["Europe/Vatican"] == time_zones(39, 669_812_345, italian_leading_zero: true)
        assert ["Europe/Rome", "Europe/Vatican"] == time_zones(39, 669_812_345)
      end
    end
  end
end
