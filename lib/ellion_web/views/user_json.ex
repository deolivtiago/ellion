defmodule EllionWeb.UserJSON do
  @moduledoc false

  alias EllionCore.Accounts.Users.User

  @doc """
  Renders a list of users
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user
  """
  def show(%{user: user}), do: %{data: data(user)}

  defp data(%User{} = user) do
    %{
      id: user.id,
      full_name: user.full_name,
      email: user.email
    }
  end
end
