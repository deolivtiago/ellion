defmodule EllionWeb.Auth.Tokens.TokenTest do
  use EllionCore.DataCase, async: true

  alias EllionCore.Factories.UsersFactory
  alias EllionWeb.Auth.Tokens

  setup do
    {:ok, user: UsersFactory.insert_user()}
  end

  describe "generate/1 returns ok" do
    test "with a pair of tokens", %{user: user} do
      assert {:ok, tokens} = Tokens.generate(user)

      assert is_binary(tokens.access)
      assert is_binary(tokens.refresh)
    end
  end
end
