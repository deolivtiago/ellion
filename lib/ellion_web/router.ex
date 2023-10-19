defmodule EllionCoreWeb.Router do
  use EllionCoreWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EllionCoreWeb do
    pipe_through :api
  end
end
