defmodule EllionCore.Accounts.UserTokens.UserToken do
  @moduledoc """
  Database schema for user tokens
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__
  alias EllionCore.Accounts.Users.User

  @required_attrs ~w(id user_id token expiration)a

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]

  schema "user_tokens" do
    field :token, :string
    field :expiration, :utc_datetime

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(%UserToken{} = user_token, attrs \\ %{}) do
    user_token
    |> cast(attrs, @required_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:id, name: :user_tokens_pkey)
    |> unique_constraint(:token)
    |> assoc_constraint(:user)
  end
end
