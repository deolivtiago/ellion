defmodule EllionWeb.AuthController do
  @moduledoc false
  use EllionWeb, :controller

  alias EllionCore.Accounts.Users
  alias EllionWeb.Auth.Tokens

  action_fallback EllionWeb.FallbackController

  @doc false
  @spec signin(Plug.Conn.t(), map) :: Plug.Conn.t()
  def signin(conn, %{"credentials" => user_credentials}) do
    with {:ok, user} <- Users.authenticate_user(user_credentials),
         {:ok, tokens} <- Tokens.generate(user) do
      render(conn, :index, tokens: tokens)
    end
  end

  @doc false
  @spec signup(Plug.Conn.t(), map) :: Plug.Conn.t()
  def signup(conn, %{"user" => user_params}) do
    with {:ok, user} <- Users.create_user(user_params),
         {:ok, tokens} <- Tokens.generate(user) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/users/#{user}")
      |> render(:index, tokens: tokens)
    end
  end
end
