defmodule EllionCore.Accounts.UserTokens.UserToken.List do
  @moduledoc false

  alias EllionCore.Accounts.UserTokens.UserToken
  alias EllionCore.Repo

  @doc false
  def call, do: Repo.all(UserToken)
end
