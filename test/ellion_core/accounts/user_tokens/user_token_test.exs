defmodule EllionCore.Accounts.UserTokens.UserTokenTest do
  use EllionCore.DataCase, async: true

  alias Ecto.Changeset
  alias EllionCore.Accounts.UserTokens.UserToken
  alias EllionCore.Factories.UserTokensFactory

  setup do
    {:ok, attrs: UserTokensFactory.user_token_attrs()}
  end

  describe "changeset/2 returns a valid changeset" do
    test "when id is valid", %{attrs: attrs} do
      changeset = UserToken.changeset(%UserToken{}, attrs)

      assert %Changeset{valid?: true, changes: changes} = changeset
      assert changes.id == attrs.id
    end

    test "when token is valid", %{attrs: attrs} do
      changeset = UserToken.changeset(%UserToken{}, attrs)

      assert %Changeset{valid?: true, changes: changes} = changeset
      assert changes.token == attrs.token
    end

    test "when expiration is valid", %{attrs: attrs} do
      changeset = UserToken.changeset(%UserToken{}, attrs)

      assert %Changeset{valid?: true, changes: changes} = changeset
      assert DateTime.compare(changes.expiration, attrs.expiration) == :eq
    end

    test "when user id is valid", %{attrs: attrs} do
      changeset = UserToken.changeset(%UserToken{}, attrs)

      assert %Changeset{valid?: true, changes: changes} = changeset
      assert changes.user_id == attrs.user_id
    end
  end

  describe "changeset/2 returns an invalid changeset" do
    test "when id is null", %{attrs: attrs} do
      attrs = Map.put(attrs, :id, nil)

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "can't be blank")
    end

    test "when id is not given", %{attrs: attrs} do
      attrs = Map.delete(attrs, :id)

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "can't be blank")
    end

    test "when id is empty", %{attrs: attrs} do
      attrs = Map.put(attrs, :id, "")

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "can't be blank")
    end

    test "when id is invalid", %{attrs: attrs} do
      attrs = Map.put(attrs, :id, 1)

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "is invalid")
    end

    test "when token is null", %{attrs: attrs} do
      attrs = Map.put(attrs, :token, nil)

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.token, "can't be blank")
    end

    test "when token is not given", %{attrs: attrs} do
      attrs = Map.delete(attrs, :token)

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.token, "can't be blank")
    end

    test "when token is empty", %{attrs: attrs} do
      attrs = Map.put(attrs, :token, "")

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.token, "can't be blank")
    end

    test "when token is invalid", %{attrs: attrs} do
      attrs = Map.put(attrs, :token, 1)

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.token, "is invalid")
    end

    test "when expiration is null", %{attrs: attrs} do
      attrs = Map.put(attrs, :expiration, nil)

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.expiration, "can't be blank")
    end

    test "when expiration is not given", %{attrs: attrs} do
      attrs = Map.delete(attrs, :expiration)

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.expiration, "can't be blank")
    end

    test "when expiration is empty", %{attrs: attrs} do
      attrs = Map.put(attrs, :expiration, "")

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.expiration, "can't be blank")
    end

    test "when expiration is invalid", %{attrs: attrs} do
      attrs = Map.put(attrs, :expiration, "expiration.invalid")

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.expiration, "is invalid")
    end

    test "when user id is null", %{attrs: attrs} do
      attrs = Map.put(attrs, :user_id, nil)

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.user_id, "can't be blank")
    end

    test "when user id is not given", %{attrs: attrs} do
      attrs = Map.delete(attrs, :user_id)

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.user_id, "can't be blank")
    end

    test "when user id is empty", %{attrs: attrs} do
      attrs = Map.put(attrs, :user_id, "")

      changeset = UserToken.changeset(%UserToken{}, attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.user_id, "can't be blank")
    end
  end
end
