defmodule EllionWeb.Auth.Tokens do
  @moduledoc """
  Tokens management
  """
  alias EllionCore.Accounts.Users
  alias EllionCore.Accounts.Users.User
  alias EllionCore.Accounts.UserTokens
  alias EllionCore.Accounts.UserTokens.UserToken
  alias EllionWeb.Auth.Tokens.Token

  @doc """
  Generates a pair of tokens

  ## Examples

    iex> generate(user)
    {:ok, %{access: "access-token", refresh: "refresh-token"}}

  """
  def generate(%User{id: user_id}) do
    with {:ok, access_token, _claims} <- Token.new(user_id, "access"),
         {:ok, refresh_token, %{"jti" => id, "exp" => exp}} <- Token.new(user_id, "refresh") do
      Map.new()
      |> Map.put(:id, id)
      |> Map.put(:user_id, user_id)
      |> Map.put(:token, refresh_token)
      |> Map.put(:expiration, DateTime.from_unix!(exp))
      |> UserTokens.create_user_token()

      {:ok, %{access: access_token, refresh: refresh_token}}
    end
  end

  @doc """
  Validates the given token

  ## Examples

      iex> validate("valid-token", "refresh")
      {:ok, %User{}}

      iex> validate("invalid-token", "access")
      {:error, %Ecto.Changeset{}}

  """
  def validate(token, type) when type in ~w(access refresh) do
    with {:ok, %{"typ" => ^type} = claims} <- Token.verify_and_validate(token),
         {:ok, user} <- get_user_by_claims(claims) do
      {:ok, user}
    else
      _error ->
        %UserToken{}
        |> Ecto.Changeset.change(%{token: token})
        |> Ecto.Changeset.add_error(:token, "is invalid")
        |> then(&{:error, &1})
    end
  end

  defp get_user_by_claims(%{"jti" => id, "typ" => "refresh"}) do
    with {:ok, user_token} <- UserTokens.get_user_token(:id, id),
         {:ok, %UserToken{user: user}} <- UserTokens.delete_user_token(user_token) do
      {:ok, user}
    end
  end

  defp get_user_by_claims(%{"sub" => id}), do: Users.get_user(:id, id)
end
