defmodule EllionCore.Accounts.UserTokens.UserToken.Delete do
  @moduledoc false

  alias EllionCore.Accounts.UserTokens.UserToken
  alias EllionCore.Repo

  @doc false
  def call(%UserToken{} = user_token) do
    with {:ok, user_token} <- Repo.delete(user_token) do
      user_token
      |> Repo.preload(:user)
      |> then(&{:ok, &1})
    end
  end
end
