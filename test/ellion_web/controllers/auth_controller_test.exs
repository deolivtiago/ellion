defmodule EllionWeb.AuthControllerTest do
  use EllionWeb.ConnCase, async: true

  alias EllionCore.Factories.UsersFactory

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

  defp insert_user(_) do
    UsersFactory.insert_user()
    |> then(&{:ok, user: &1})
  end
end
