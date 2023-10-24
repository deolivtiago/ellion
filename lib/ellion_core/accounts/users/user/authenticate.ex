defmodule EllionCore.Accounts.Users.User.Authenticate do
  @moduledoc false

  alias EllionCore.Accounts.Users.User
  alias EllionCore.Repo

  @doc false
  def call(user_credentials) do
    with {:ok, %{email: email, password: password}} <- User.validate_credentials(user_credentials) do
      user = Repo.get_by(User, email: email)

      if valid_credentials?(user, password) do
        {:ok, user}
      else
        %User{}
        |> Ecto.Changeset.change(%{email: email, password: password})
        |> Ecto.Changeset.add_error(:email, "invalid credentials")
        |> Ecto.Changeset.add_error(:password, "invalid credentials")
        |> then(&{:error, &1})
      end
    end
  end

  defp valid_credentials?(%User{} = user, password) do
    Argon2.verify_pass(password, user.password_hash)
  end

  defp valid_credentials?(_nil, _password), do: Argon2.no_user_verify()
end
