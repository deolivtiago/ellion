defmodule EllionWeb.AuthJSONTest do
  use EllionWeb.ConnCase, async: true

  alias EllionWeb.AuthJSON

  test "renders a pair of auth tokens" do
    tokens = %{access: "access_token", refresh: "refresh_token"}

    assert %{data: %{tokens: tokens}} == AuthJSON.index(%{tokens: tokens})
  end
end
