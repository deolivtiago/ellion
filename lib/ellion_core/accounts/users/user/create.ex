defmodule EllionCore.Accounts.Users.User.Create do
  @moduledoc false

  alias EllionCore.Accounts.Users.User
  alias EllionCore.Repo

  @doc false
  def call(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
