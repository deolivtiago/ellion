defmodule EllionWeb.AuthJSON do
  @moduledoc false

  @doc """
  Renders auth tokens
  """
  def index(%{tokens: tokens}), do: %{data: %{tokens: tokens}}
end
