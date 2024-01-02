defmodule EllionWeb.Auth.Tokens.TokenTest do
  use EllionCore.DataCase, async: true

  alias EllionCore.Factories.UsersFactory
  alias EllionWeb.Auth.Tokens

  setup do
    UsersFactory.insert_user()
    |> Map.put(:password, nil)
    |> then(&{:ok, user: &1})
  end

  describe "generate/1" do
    test "returns ok when user is valid", %{user: user} do
      assert {:ok, tokens} = Tokens.generate(user)

      assert is_binary(tokens.access)
      assert is_binary(tokens.refresh)
    end

    test "raises an error when user is invalid" do
      assert_raise FunctionClauseError, fn -> Tokens.generate(nil) end
    end
  end

  describe "validate/1" do
    test "returns ok when the given token is valid", %{user: user} do
      {:ok, %{access: access, refresh: refresh}} = Tokens.generate(user)

      assert {:ok, user} == Tokens.validate(access, "access")
      assert {:ok, user} == Tokens.validate(refresh, "refresh")
    end

    test "returns error when the given token is invalid", %{user: user} do
      {:ok, %{access: access, refresh: refresh}} = Tokens.generate(user)

      assert {:error, %Ecto.Changeset{}} = Tokens.validate(access, "refresh")
      assert {:error, %Ecto.Changeset{}} = Tokens.validate(refresh, "access")
      assert {:error, %Ecto.Changeset{}} = Tokens.validate("", "access")
    end
  end
end
