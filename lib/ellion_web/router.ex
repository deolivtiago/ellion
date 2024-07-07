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
    get "/confirm-email", AuthController, :confirm_email
  end

  scope "/", EllionWeb do
    pipe_through [:api, :auth]

    get "/refresh", AuthController, :refresh

    resources "/users", UserController, except: [:new, :edit]
  end

  # Enable Swoosh mailbox preview in development
  if Application.compile_env(:ellion, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
