defmodule EllionWeb.UserController do
  @moduledoc false
  use EllionWeb, :controller

  alias EllionWeb.Auth.Tokens
  alias EllionCore.Accounts.Users
  alias EllionCore.Accounts.UserEmails

  action_fallback EllionWeb.FallbackController

  @doc false
  def index(conn, _params) do
    users = Users.list_users()

    render(conn, :index, users: users)
  end

  @doc false
  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Users.create_user(user_params),
         {:ok, token} <- Tokens.generate_token(user, "confirm_email") do
      UserEmails.send_instructions(:confirm_email, user, ~p"/confirm-email?code=#{token}")

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/users/#{user}")
      |> render(:show, user: user)
    end
  end

  @doc false
  def show(conn, %{"id" => id}) do
    with {:ok, user} <- Users.get_user(:id, id) do
      render(conn, :show, user: user)
    end
  end

  @doc false
  def update(conn, %{"id" => id, "user" => user_params}) do
    with {:ok, user} <- Users.get_user(:id, id),
         {:ok, user} <- Users.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  @doc false
  def delete(conn, %{"id" => id}) do
    with {:ok, user} <- Users.get_user(:id, id),
         {:ok, _user} <- Users.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
