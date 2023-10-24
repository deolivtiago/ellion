defmodule EllionCore.Accounts.UsersTest do
  use EllionCore.DataCase, async: true

  alias Ecto.Changeset
  alias EllionCore.Accounts.Users
  alias EllionCore.Factories.UsersFactory
  alias Users.User

  setup do
    {:ok, attrs: UsersFactory.user_attrs()}
  end

  describe "list_users/0" do
    test "without users returns an empty list" do
      assert [] == Users.list_users()
    end

    test "with users returns all users" do
      user = UsersFactory.insert_user() |> Map.put(:password, nil)

      assert [user] == Users.list_users()
    end
  end

  describe "get_user/2 returns ok" do
    setup [:insert_user]

    test "when the given id is found", %{user: user} do
      assert {:ok, %User{} = user} == Users.get_user(:id, user.id)
    end

    test "when the given email is found", %{user: user} do
      assert {:ok, %User{} = user} == Users.get_user(:email, user.email)
    end
  end

  describe "get_user/2 returns error" do
    test "when the given id is not found" do
      id = Ecto.UUID.generate()

      assert {:error, changeset} = Users.get_user(:id, id)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "not found")
    end

    test "when the given id is invalid" do
      assert {:error, changeset} = Users.get_user(:id, 1)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "is invalid")
    end

    test "when the given email is not found" do
      email = Faker.Internet.email()

      assert {:error, changeset} = Users.get_user(:email, email)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "not found")
    end

    test "when the given email is invalid" do
      assert {:error, changeset} = Users.get_user(:email, 1)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "is invalid")
    end
  end

  describe "get_user/2 raises the error" do
    test "when it is not handled" do
      assert_raise ArgumentError, fn -> Users.get_user(:id, nil) end
    end
  end

  describe "create_user/1 returns ok" do
    test "when the user attributes are valid", %{attrs: attrs} do
      assert {:ok, %User{} = user} = Users.create_user(attrs)

      assert user.email == attrs.email
      assert user.full_name == attrs.full_name
      assert Argon2.verify_pass(attrs.password, user.password_hash)
    end
  end

  describe "create_user/1 returns error" do
    test "when the user attributes are invalid" do
      attrs = %{email: "???", full_name: nil, password: "?"}

      assert {:error, changeset} = Users.create_user(attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "has invalid format")
      assert Enum.member?(errors.full_name, "can't be blank")
      assert Enum.member?(errors.password, "should be at least 6 character(s)")
    end

    test "when the user email already exists", %{attrs: attrs} do
      attrs = Map.put(attrs, :email, UsersFactory.insert_user().email)

      assert {:error, changeset} = Users.create_user(attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "has already been taken")
    end
  end

  describe "update_user/2 returns ok" do
    setup [:insert_user]

    test "when the user attributes are valid", %{user: %{id: id} = user, attrs: attrs} do
      assert {:ok, %User{} = user} = Users.update_user(user, attrs)

      assert id == user.id
      assert attrs.id != user.id
      assert attrs.email == user.email
      assert attrs.full_name == user.full_name
      assert Argon2.verify_pass(attrs.password, user.password_hash)
    end
  end

  describe "update_user/2 returns error" do
    setup [:insert_user]

    test "when the user attributes are invalid", %{user: user} do
      invalid_attrs = %{email: "?@?", full_name: "?", password: nil}

      assert {:error, changeset} = Users.update_user(user, invalid_attrs)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "has invalid format")
      assert Enum.member?(errors.full_name, "should be at least 2 character(s)")
      assert Enum.member?(errors.password, "can't be blank")
    end
  end

  describe "delete_user/1 returns ok" do
    setup [:insert_user]

    test "when the user is deleted", %{user: user} do
      assert {:ok, %User{}} = Users.delete_user(user)

      assert {:error, changeset} = Users.get_user(:id, user.id)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.id, "not found")
    end
  end

  describe "authenticate/1 returns" do
    test "ok when credentials are valid" do
      user = UsersFactory.insert_user()
      credentials = %{email: user.email, password: user.password}

      assert {:ok, Map.put(user, :password, nil)} == Users.authenticate_user(credentials)
    end

    test "error when credentials are invalid" do
      credentials = %{email: "other@mail.com", password: "invalid"}

      assert {:error, changeset} = Users.authenticate_user(credentials)
      errors = errors_on(changeset)

      assert %Changeset{valid?: false} = changeset
      assert Enum.member?(errors.email, "invalid credentials")
      assert Enum.member?(errors.password, "invalid credentials")
    end
  end

  defp insert_user(_) do
    UsersFactory.insert_user()
    |> Map.put(:password, nil)
    |> then(&{:ok, user: &1})
  end
end
