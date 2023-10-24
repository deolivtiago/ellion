defmodule EllionCore.Accounts.Users.User do
  @moduledoc """
  Database schema for users
  """
  use Ecto.Schema

  import Ecto.Changeset

  alias __MODULE__

  @required_attrs ~w(full_name email password)a
  @optional_attrs ~w(is_disabled)a

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @timestamps_opts [type: :utc_datetime]

  schema "users" do
    field :full_name, :string
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :password_hash, :string
    field :is_disabled, :boolean, default: false

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs \\ %{}) do
    user
    |> cast(attrs, @required_attrs ++ @optional_attrs)
    |> validate_required(@required_attrs)
    |> unique_constraint(:id, name: :users_pkey)
    |> unique_constraint(:email)
    |> validate_length(:full_name, min: 2, max: 255)
    |> validate_length(:email, min: 3, max: 255)
    |> validate_length(:password, min: 6, max: 255)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/^[a-z0-9\-._+&#$?!]+[@][a-z0-9\-._+]+$/)
    |> put_pass_hash()
  end

  defp put_pass_hash(%{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, Argon2.hash_pwd_salt(password))
  end

  defp put_pass_hash(changeset), do: changeset

  @doc """
  Validates user credentials

  ## Examples

      iex> validate_credentials(valid_credentials)
      {:ok, %User{}}

      iex> validate_credentials(invalid_credentials)
      {:error, %Ecto.Changeset{}}

  """
  def validate_credentials(credentials \\ %{}) do
    %User{}
    |> cast(credentials, ~w(email password)a)
    |> validate_required(~w(email password)a)
    |> update_change(:email, &String.downcase/1)
    |> validate_format(:email, ~r/^[a-z0-9\-._+&#$?!]+[@][a-z0-9\-._+]+$/)
    |> apply_action(:validate)
  end
end
