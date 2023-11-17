defmodule EllionWeb.Auth.Tokens do
  @moduledoc """
  Tokens management
  """
  alias EllionCore.Accounts.Users
  alias EllionCore.Accounts.Users.User
  alias EllionWeb.Auth.Tokens.Token

  @doc """
  Generates a pair of tokens

  ## Examples

    iex> generate(user)
    {:ok, %{access: "access-token", refresh: "refresh-token"}}

  """
  def generate(%User{id: id}) do
    with {:ok, access_token, _claims} <- Token.new(id, "access"),
         {:ok, refresh_token, _claims} <- Token.new(id, "refresh") do
      {:ok, %{access: access_token, refresh: refresh_token}}
    end
  end

  @doc """
  Validates the given token

  ## Examples

      iex> validate("valid-token")
      {:ok, %User{}}

      iex> validate("invalid-token")
      {:error, %Ecto.Changeset{}}

  """
  def validate(token) do
    with {:ok, %{"sub" => id}} <- Token.verify_and_validate(token),
         {:ok, user} <- Users.get_user(:id, id) do
      {:ok, user}
    else
      _error ->
        %Ecto.Changeset{}
        |> Ecto.Changeset.add_error(:token, "is invalid")
        |> then(&{:error, &1})
    end
  end
end
