defmodule EllionWeb.UserJSONTest do
  use EllionWeb.ConnCase, async: true

  alias EllionCore.Factories.UsersFactory
  alias EllionWeb.UserJSON

  describe "renders" do
    setup [:build_user]

    test "a list of users", %{user: user} do
      assert %{data: [user_data]} = UserJSON.index(%{users: [user]})

      assert user_data.id == user.id
      assert user_data.full_name == user.full_name
      assert user_data.email == user.email
    end

    test "a single user", %{user: user} do
      assert %{data: user_data} = UserJSON.show(%{user: user})

      assert user_data.id == user.id
      assert user_data.full_name == user.full_name
      assert user_data.email == user.email
    end
  end

  defp build_user(_) do
    UsersFactory.build_user()
    |> Map.put(:password, nil)
    |> then(&{:ok, user: &1})
  end
end
