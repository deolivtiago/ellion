defmodule EllionCore.Location.CitiesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EllionCore.Location.Cities` context.
  """

  @doc """
  Generate a city.
  """
  def city_fixture(attrs \\ %{}) do
    {:ok, city} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> EllionCore.Location.Cities.create_city()

    city
  end
end
