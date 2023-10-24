defmodule EllionCore.Accounts.Users.User.Get do
  @moduledoc false

  alias EllionCore.Accounts.Users.User
  alias EllionCore.Repo

  @doc false
  def call(:id, id), do: get_by(:id, id)
  def call(:email, email), do: get_by(:email, email)

  defp get_by(key, value) do
    User
    |> Repo.get_by!([{key, value}])
    |> then(&{:ok, &1})
  rescue
    Ecto.Query.CastError ->
      handle_error(key, value, "is invalid")

    Ecto.NoResultsError ->
      handle_error(key, value, "not found")

    error ->
      reraise error, __STACKTRACE__
  end

  defp handle_error(key, value, message) do
    %User{}
    |> Ecto.Changeset.change([{key, value}])
    |> Ecto.Changeset.add_error(key, message)
    |> then(&{:error, &1})
  end
end
