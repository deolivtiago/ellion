defmodule EllionCore.Accounts.UserTokens.UserToken.Create do
  @moduledoc false

  alias EllionCore.Accounts.UserTokens.UserToken
  alias EllionCore.Repo

  @doc false
  def call(attrs \\ %{}) do
    %UserToken{}
    |> UserToken.changeset(attrs)
    |> Repo.insert()
  end
end
