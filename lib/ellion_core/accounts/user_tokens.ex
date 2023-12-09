defmodule EllionCore.Accounts.UserTokens do
  @moduledoc """
  User Tokens management
  """

  alias EllionCore.Accounts.UserTokens.UserToken

  @doc """
  Lists all user tokens

  ## Examples

      iex> list_user_tokens()
      [%UserToken{}, ...]

  """
  defdelegate list_user_tokens, to: UserToken.List, as: :call

  @doc """
  Gets an user token

  ## Examples

      iex> get_user_token(field, value)
      {:ok, %User{}}

      iex> get_user_token(field, bad_value)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate get_user_token(field, value), to: UserToken.Get, as: :call

  @doc """
  Creates an user token

  ## Examples

      iex> create_user_token(%{field: value})
      {:ok, %User{}}

      iex> create_user_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  defdelegate create_user_token(attrs), to: UserToken.Create, as: :call

  @doc """
  Deletes an user token

  ## Examples

      iex> delete_user_token(user_token)
      {:ok, %User{}}

      iex> delete_user_token(user_token)
      {:error, %Ecto.Changeset{}}

  """
  defdelegate delete_user_token(user_token), to: UserToken.Delete, as: :call
end
