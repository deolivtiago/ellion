defmodule EllionCore.Accounts.Users.User.List do
  @moduledoc false

  alias EllionCore.Accounts.Users.User
  alias EllionCore.Repo

  @doc false
  def call, do: Repo.all(User)
end
