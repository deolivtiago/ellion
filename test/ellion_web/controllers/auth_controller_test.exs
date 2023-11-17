defmodule EllionWeb.AuthControllerTest do
  use EllionWeb.ConnCase, async: true

  alias EllionCore.Factories.UsersFactory
  alias EllionWeb.Auth.Tokens

  setup %{conn: conn} do
    conn
    |> put_req_header("accept", "application/json")
    |> then(&{:ok, conn: &1})
  end

  describe "signup/2 returns success" do
    setup [:insert_user]

    test "when the user parameters are valid", %{conn: conn} do
      user_params = UsersFactory.user_attrs()

      conn = post(conn, ~p"/signup", user: user_params)

      assert %{"data" => %{"tokens" => tokens}} = json_response(conn, :created)

      assert is_binary(tokens["access"])
      assert is_binary(tokens["refresh"])
    end
  end

  describe "signup/2 returns error" do
    test "when the user parameters are invalid", %{conn: conn} do
      user_params = %{email: "???", full_name: nil, password: "?"}

      conn = post(conn, ~p"/signup", user: user_params)

      assert %{"errors" => errors} = json_response(conn, :unprocessable_entity)

      assert Enum.member?(errors["email"], "has invalid format")
      assert Enum.member?(errors["full_name"], "can't be blank")
      assert Enum.member?(errors["password"], "should be at least 6 character(s)")
    end
  end

  describe "signin/2 returns success" do
    setup [:insert_user]

    test "when the user credentials are valid", %{conn: conn, user: user} do
      user_credentials = %{email: user.email, password: user.password}

      conn = post(conn, ~p"/signin", credentials: user_credentials)

      assert %{"data" => %{"tokens" => tokens}} = json_response(conn, :ok)

      assert is_binary(tokens["access"])
      assert is_binary(tokens["refresh"])
    end
  end

  describe "signin/2 returns error" do
    test "when the user credentials are invalid", %{conn: conn} do
      user_credentials = %{email: "???", password: nil}

      conn = post(conn, ~p"/signin", credentials: user_credentials)

      assert %{"errors" => errors} = json_response(conn, :unprocessable_entity)

      assert Enum.member?(errors["email"], "has invalid format")
      assert Enum.member?(errors["password"], "can't be blank")
    end
  end

  describe "refresh/1 returns ok" do
    setup [:insert_user, :put_token]

    test "when token is invalid", %{conn: conn} do
      conn = get(conn, ~p"/refresh")

      assert %{"data" => %{"tokens" => tokens}} = json_response(conn, :ok)

      assert is_binary(tokens["access"])
      assert is_binary(tokens["refresh"])
    end
  end

  describe "refresh/1 returns error" do
    test "when token is not found", %{conn: conn} do
      assert response(get(conn, ~p"/refresh"), :unauthorized)
    end

    test "when token is invalid", %{conn: conn} do
      conn = put_req_header(conn, "authorization", "Bearer invalid_token")

      assert response(get(conn, ~p"/refresh"), :unauthorized)
    end
  end

  defp insert_user(_) do
    UsersFactory.insert_user()
    |> then(&{:ok, user: &1})
  end

  defp put_token(%{conn: conn, user: user}) do
    {:ok, %{refresh: token}} = Tokens.generate(user)

    conn
    |> put_req_header("authorization", "Bearer " <> token)
    |> then(&{:ok, conn: &1})
  end
end
