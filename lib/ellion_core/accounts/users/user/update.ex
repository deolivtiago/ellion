defmodule EllionCore.Accounts.Users.User.Update do
  @moduledoc false

  alias EllionCore.Accounts.Users.User
  alias EllionCore.Repo

  @doc false
  def call(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end
end
