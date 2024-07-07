defmodule EllionWeb.Auth.Tokens do
  @moduledoc """
  Tokens management
  """
  alias EllionCore.Accounts.Users.User
  alias EllionCore.Accounts.UserTokens
  alias EllionCore.Accounts.UserTokens.UserToken
  alias EllionWeb.Auth.Tokens.Token

  @token_types ~w(access refresh confirm_email reset_password change_email)

  @doc """
  Generates a token with the given type

  ## Examples

    iex> generate_token(%User{}, "access")
    {:ok, "access-token"}}

  """
  def generate_token(%User{id: sub}, type) when is_binary(sub) and type in @token_types do
    with {:ok, token, claims} <- Token.new(sub, type),
         {:ok, _user_token} <- insert_user_token(token, claims) do
      {:ok, token}
    end
  end

  @doc """
  Validates a token with the given type

  ## Examples

      iex> validate_token("valid-token", "refresh")
      {:ok, %User{}}

      iex> validate_token("invalid-token", "access")
      {:error, %Ecto.Changeset{}}

  """
  def validate_token(token, type) when type in @token_types do
    with {:ok, %{"typ" => ^type, "jti" => id}} <- Token.verify_and_validate(token),
         {:ok, user_token} <- UserTokens.get_user_token(:id, id),
         {:ok, %UserToken{user: user}} <- UserTokens.delete_user_token(user_token) do
      {:ok, user}
    else
      _error ->
        %UserToken{}
        |> Ecto.Changeset.change(%{token: token})
        |> Ecto.Changeset.add_error(:token, "is invalid")
        |> then(&{:error, &1})
    end
  end

  defp insert_user_token(token, claims) when is_binary(token) and is_map(claims) do
    Map.new()
    |> Map.put(:id, claims["jti"])
    |> Map.put(:user_id, claims["sub"])
    |> Map.put(:token, token)
    |> Map.put(:type, claims["typ"])
    |> Map.put(:expiration, DateTime.from_unix!(claims["exp"]))
    |> UserTokens.create_user_token()
  end
end
