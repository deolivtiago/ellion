defmodule EllionCore.Factories.UsersFactory do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EllionCore.Accounts.Users` context.
  """

  alias EllionCore.Accounts.Users.User
  alias EllionCore.Repo

  @doc """
  Generate fake user attrs

    ## Examples

      iex> user_attrs()
      %{field: value, ...}

  """
  def user_attrs do
    password = Base.encode64(:crypto.strong_rand_bytes(32), padding: false)

    %{
      id: Faker.UUID.v4(),
      full_name: Faker.Person.name(),
      email: Faker.Internet.email(),
      password: password,
      password_hash: Argon2.hash_pwd_salt(password),
      is_inactive: false,
      inserted_at: Faker.DateTime.backward(366),
      updated_at: DateTime.utc_now()
    }
  end

  @doc """
  Builds a fake user

    ## Examples

      iex> build_user()
      %User{field: value, ...}

  """
  def build_user do
    %User{}
    |> User.changeset(user_attrs())
    |> Ecto.Changeset.apply_action!(nil)
  end

  @doc """
  Inserts a fake user

    ## Examples

      iex> insert_user()
      %User{field: value, ...}

  """
  def insert_user do
    %User{}
    |> User.changeset(user_attrs())
    |> Repo.insert!()
  end
end
