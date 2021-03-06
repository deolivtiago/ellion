defmodule Ellion.Geo do
  @moduledoc """
  Geolocation context.
  """

  import Ecto.Query, warn: false

  alias Ellion.Geo.City
  alias Ellion.Geo.Country
  alias Ellion.Geo.State
  alias Ellion.Repo

  @doc """
  Returns the list of countries.

  ## Examples

      iex> list_countries()
      [%Country{}, ...]

  """
  def list_countries, do: Repo.all(Country)

  @doc """
  Gets a single country.

  ## Examples

      iex> get_country(valid_uuid)
      {:ok, %Country{}}

      iex> get_country(invalid_uuid)
      {:error, %Ecto.Changeset{}}

  """
  def get_country(id) do
    country = Repo.get!(Country, id)

    {:ok, country}
  rescue
    Ecto.NoResultsError ->
      {:error, Country.error_changeset(:id, id, "not found [country]")}

    Ecto.Query.CastError ->
      {:error, Country.error_changeset(:id, id, "invalid format [country]")}
  end

  @doc """
  Creates a country.

  ## Examples

      iex> create_country(%{field: value})
      {:ok, %Country{}}

      iex> create_country(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_country(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a country.

  ## Examples

      iex> update_country(country, %{field: new_value})
      {:ok, %Country{}}

      iex> update_country(country, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_country(%Country{} = country, attrs) do
    country
    |> Country.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a country.

  ## Examples

      iex> delete_country(country)
      {:ok, %Country{}}

      iex> delete_country(country)
      {:error, %Ecto.Changeset{}}

  """
  def delete_country(%Country{} = country) do
    Repo.delete(country)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking country changes.

  ## Examples

      iex> change_country(country)
      %Ecto.Changeset{data: %Country{}}

  """
  def change_country(%Country{} = country, attrs \\ %{}) do
    Country.changeset(country, attrs)
  end

  @doc """
  Returns the list of states.

  ## Examples

      iex> list_states()
      [%State{}, ...]

  """
  def list_states, do: Repo.all(State)

  def list_states(country_id) do
    Repo.all(from s in State, where: s.country_id == ^country_id)
  end

  @doc """
  Gets a single state.

  ## Examples

      iex> get_state(valid_uuid)
      {:ok, %State{}}

      iex> get_state(invalid_uuid)
      {:error, %Ecto.Changeset{}}

  """
  def get_state(id) do
    state = Repo.get!(State, id)

    {:ok, state}
  rescue
    Ecto.NoResultsError ->
      {:error, State.error_changeset(:id, id, "not found [state]")}

    Ecto.Query.CastError ->
      {:error, State.error_changeset(:id, id, "invalid format [state]")}
  end

  @doc """
  Creates a state.

  ## Examples

      iex> create_state(%{field: value})
      {:ok, %State{}}

      iex> create_state(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_state(attrs \\ %{}) do
    %State{}
    |> State.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a state.

  ## Examples

      iex> update_state(state, %{field: new_value})
      {:ok, %State{}}

      iex> update_state(state, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_state(%State{} = state, attrs) do
    state
    |> State.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a state.

  ## Examples

      iex> delete_state(state)
      {:ok, %State{}}

      iex> delete_state(state)
      {:error, %Ecto.Changeset{}}

  """
  def delete_state(%State{} = state) do
    Repo.delete(state)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking state changes.

  ## Examples

      iex> change_state(state)
      %Ecto.Changeset{data: %State{}}

  """
  def change_state(%State{} = state, attrs \\ %{}) do
    State.changeset(state, attrs)
  end

  @doc """
  Returns the list of cities.

  ## Examples

      iex> list_cities()
      [%City{}, ...]

  """
  def list_cities, do: Repo.all(City)

  def list_cities(state_id) do
    Repo.all(from c in City, where: c.state_id == ^state_id)
  end

  @doc """
  Gets a single city.

  ## Examples

      iex> get_city(valid_uuid)
      {:ok, %City{}}

      iex> get_city(invalid_uuid)
      {:error, %Ecto.Changeset{}}

  """
  def get_city(id) do
    city = Repo.get!(City, id)

    {:ok, city}
  rescue
    Ecto.NoResultsError ->
      {:error, City.error_changeset(:id, id, "not found [city]")}

    Ecto.Query.CastError ->
      {:error, City.error_changeset(:id, id, "invalid format [city]")}
  end

  @doc """
  Creates a city.

  ## Examples

      iex> create_city(%{field: value})
      {:ok, %City{}}

      iex> create_city(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_city(attrs \\ %{}) do
    %City{}
    |> City.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a city.

  ## Examples

      iex> update_city(city, %{field: new_value})
      {:ok, %City{}}

      iex> update_city(city, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_city(%City{} = city, attrs) do
    city
    |> City.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a city.

  ## Examples

      iex> delete_city(city)
      {:ok, %City{}}

      iex> delete_city(city)
      {:error, %Ecto.Changeset{}}

  """
  def delete_city(%City{} = city) do
    Repo.delete(city)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking city changes.

  ## Examples

      iex> change_city(city)
      %Ecto.Changeset{data: %City{}}

  """
  def change_city(%City{} = city, attrs \\ %{}) do
    City.changeset(city, attrs)
  end
end
