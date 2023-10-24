defmodule EllionWeb.Auth.Tokens do
  @moduledoc """
  Tokens management
  """
  alias EllionCore.Accounts.Users.User
  alias EllionWeb.Auth.Tokens.Token

  @doc """
  Generates a pair of tokens

  ## Examples

    iex> generate(user)
    {:ok, %{access: "access-token-2n13jn", refresh: "refresh-token-j31ij5"}}

  """
  def generate(%User{id: id}) do
    with {:ok, access_token, _claims} <- Token.new(id, "access"),
         {:ok, refresh_token, _claims} <- Token.new(id, "refresh") do
      {:ok, %{access: access_token, refresh: refresh_token}}
    end
  end
end
