defmodule EllionWeb.Router do
  use EllionWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EllionWeb do
    pipe_through :api
  end
end
