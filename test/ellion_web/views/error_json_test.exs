defmodule EllionWeb.ErrorJSONTest do
  use EllionWeb.ConnCase, async: true

  alias EllionWeb.ErrorJSON

  test "renders 500" do
    assert ErrorJSON.render("500.json", %{}) == %{errors: %{detail: "Internal Server Error"}}
  end
end
