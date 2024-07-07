defmodule EllionWeb.AuthController do
  @moduledoc false
  use EllionWeb, :controller

  alias EllionCore.Accounts.Users
  alias EllionCore.Accounts.UserEmails
  alias EllionWeb.Auth.Tokens

  action_fallback EllionWeb.FallbackController

  @doc false
  def signin(conn, %{"credentials" => user_credentials}) do
    with {:ok, user} <- Users.authenticate_user(user_credentials),
         {:ok, access_token} <- Tokens.generate_token(user, "access"),
         {:ok, refresh_token} <- Tokens.generate_token(user, "refresh") do
      render(conn, :index, tokens: %{access: access_token, refresh: refresh_token})
    end
  end

  @doc false
  def signup(conn, %{"user" => user_params}) do
    with {:ok, user} <- Users.create_user(user_params),
         {:ok, access_token} <- Tokens.generate_token(user, "access"),
         {:ok, refresh_token} <- Tokens.generate_token(user, "refresh"),
         {:ok, confirm_code} <- Tokens.generate_token(user, "confirm_email") do
      UserEmails.send_instructions(:confirm_email, user, ~p"/confirm-email?code=#{confirm_code}")

      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/users/#{user}")
      |> render(:index, tokens: %{access: access_token, refresh: refresh_token})
    end
  end

  @doc false
  def refresh(%{assigns: %{current_user: user}} = conn, _params) do
    with {:ok, access_token} <- Tokens.generate_token(user, "access"),
         {:ok, refresh_token} <- Tokens.generate_token(user, "refresh") do
      render(conn, :index, tokens: %{access: access_token, refresh: refresh_token})
    end
  end

  @doc false
  def confirm_email(conn, %{"code" => confirm_code}) do
    with {:ok, user} <- Tokens.validate_token(confirm_code, "confirm_email") |> IO.inspect(),
         {:ok, _user} <- Users.update_user(user, %{is_disabled: false}) |> IO.inspect() do
      send_resp(conn, :ok, "")
    end
  end
end
