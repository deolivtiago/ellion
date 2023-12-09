defmodule EllionCore.Accounts.UserTokensTest do
  use EllionCore.DataCase, async: true

  alias Ecto.Changeset
  alias EllionCore.Accounts.UserTokens
  alias EllionCore.Factories.UserTokensFactory
  alias UserTokens.UserToken

  setup do
    {:ok, attrs: UserTokensFactory.user_token_attrs()}
  end

  describe "list_user_tokens/0" do
    test "without user_tokens returns an empty list" do
      assert [] == UserTokens.list_user_tokens()
    end

    test "with user_tokens returns all user_tokens" do
      user_token = UserTokensFactory.insert_user_token() |> Ecto.reset_fields([:user])

      assert [user_token] == UserTokens.list_user_tokens()
    end
  end

  describe "get_user_token/2 returns ok" do
    setup [:insert_user_token]

    test "when the given id is found", %{user_token: user_token} do
      assert {:ok, %UserToken{} = user_token} == UserTokens.get_user_token(:id, user_token.id)
    end

    test "when the given token is found", %{user_token: user_token} do
      assert {:ok, %UserToken{} = user_token} ==
               UserTokens.get_user_token(:token, user_token.token)
    end
  end

  describe "get_user_token/2 returns error" do
    test "when the given id is not found" do
      id = Ecto.UUID.generate()

      assert {:error, changeset} = UserTokens.get_user_token(:id, id)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "not found")
    end

    test "when the given id is invalid" do
      assert {:error, changeset} = UserTokens.get_user_token(:id, 1)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "is invalid")
    end

    test "when the given token is not found" do
      assert {:error, changeset} = UserTokens.get_user_token(:token, "token.not_found")
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.token, "not found")
    end

    test "when the given token is invalid" do
      assert {:error, changeset} = UserTokens.get_user_token(:token, 1)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.token, "is invalid")
    end
  end

  describe "get_user_token/2 raises the error" do
    test "when it is not handled" do
      assert_raise ArgumentError, fn -> UserTokens.get_user_token(:id, nil) end
    end
  end

  describe "create_user_token/1 returns ok" do
    test "when the user token attributes are valid", %{attrs: attrs} do
      assert {:ok, %UserToken{} = user_token} = UserTokens.create_user_token(attrs)

      assert user_token.id == attrs.id
      assert user_token.token == attrs.token
      assert user_token.user_id == attrs.user_id
      assert DateTime.compare(attrs.expiration, user_token.expiration) == :eq
    end
  end

  describe "create_user_token/1 returns error" do
    test "when the user token attributes are invalid" do
      attrs = %{token: "", id: 1, expiration: "?"}

      assert {:error, changeset} = UserTokens.create_user_token(attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "is invalid")
      assert Enum.member?(errors.token, "can't be blank")
      assert Enum.member?(errors.expiration, "is invalid")
    end

    test "when the id already exists", %{attrs: attrs} do
      attrs = Map.put(attrs, :id, UserTokensFactory.insert_user_token().id)

      assert {:error, changeset} = UserTokens.create_user_token(attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "has already been taken")
    end

    test "when the token already exists", %{attrs: attrs} do
      attrs = Map.put(attrs, :token, UserTokensFactory.insert_user_token().token)

      assert {:error, changeset} = UserTokens.create_user_token(attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.token, "has already been taken")
    end
  end

  describe "delete_user_token/1 returns ok" do
    setup [:insert_user_token]

    test "when the user token was deleted", %{user_token: user_token} do
      assert {:ok, %UserToken{}} = UserTokens.delete_user_token(user_token)

      assert {:error, changeset} = UserTokens.get_user_token(:id, user_token.id)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "not found")
    end
  end

  defp insert_user_token(_) do
    UserTokensFactory.insert_user_token()
    |> then(&{:ok, user_token: &1})
  end
end
