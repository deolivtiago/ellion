defmodule EllionCore.Accounts.Users.User.Delete do
  @moduledoc false

  alias EllionCore.Accounts.Users.User
  alias EllionCore.Repo

  @doc false
  def call(%User{} = user), do: Repo.delete(user)
end
