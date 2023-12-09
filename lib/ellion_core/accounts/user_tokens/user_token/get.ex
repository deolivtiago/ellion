defmodule EllionCore.Accounts.UserTokens.UserToken.Get do
  @moduledoc false
  import Ecto.Query

  alias EllionCore.Accounts.UserTokens.UserToken
  alias EllionCore.Repo

  @doc false
  def call(:id, id), do: get_by(:id, id)
  def call(:token, token), do: get_by(:token, token)

  defp get_by(key, value) do
    query =
      from ut in UserToken,
        where: ut.expiration > ^DateTime.utc_now(:second)

    query
    |> Repo.get_by!([{key, value}])
    |> Repo.preload(:user)
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
    %UserToken{}
    |> Ecto.Changeset.change([{key, value}])
    |> Ecto.Changeset.add_error(key, message)
    |> then(&{:error, &1})
  end
end
