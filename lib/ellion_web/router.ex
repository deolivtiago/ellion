defmodule EllionWeb.Router do
  use EllionWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug EllionWeb.Plugs.AuthenticationPlug
  end

  scope "/", EllionWeb do
    pipe_through :api

    post "/signup", AuthController, :signup
    post "/signin", AuthController, :signin
  end

  scope "/", EllionWeb do
    pipe_through [:api, :auth]

    get "/refresh", AuthController, :refresh

    resources "/users", UserController, except: [:new, :edit]
  end
end
