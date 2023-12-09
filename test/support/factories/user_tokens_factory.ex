defmodule EllionCore.Factories.UserTokensFactory do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EllionCore.Accounts.UserTokens` context.
  """

  alias EllionCore.Accounts.Users.User
  alias EllionCore.Accounts.UserTokens.UserToken
  alias EllionCore.Factories.UsersFactory
  alias EllionCore.Repo
  alias EllionWeb.Auth.Tokens

  @doc """
  Generate fake user token attrs

    ## Examples

      iex> user_token_attrs()
      %{field: value, ...}

      iex> user_token_attrs(%User{})
      %{field: value, ...}

  """
  def user_token_attrs do
    UsersFactory.insert_user()
    |> user_token_attrs()
  end

  def user_token_attrs(%User{id: id} = user) do
    {:ok, token, _claims} = Tokens.Token.new(id, "refresh")

    %{
      id: Faker.UUID.v4(),
      token: token,
      expiration: Faker.DateTime.forward(14) |> DateTime.truncate(:second),
      user_id: id,
      user: user,
      inserted_at: Faker.DateTime.backward(366),
      updated_at: DateTime.utc_now()
    }
  end

  @doc """
  Builds a fake user token

    ## Examples

      iex> build_user_token()
      %UserToken{field: value, ...}

  """
  def build_user_token do
    %UserToken{}
    |> UserToken.changeset(user_token_attrs())
    |> Ecto.Changeset.apply_action!(nil)
  end

  @doc """
  Inserts a fake user token

    ## Examples

      iex> insert_user_token()
      %UserToken{field: value, ...}

  """
  def insert_user_token do
    %UserToken{}
    |> UserToken.changeset(user_token_attrs())
    |> Repo.insert!()
    |> Repo.preload(:user)
  end
end
