defmodule EllionCore.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :full_name, :string, null: false
      add :email, :string, null: false
      add :password_hash, :string, null: false
      add :is_disabled, :boolean, default: false, null: false

      timestamps(type: :timestamptz)
    end

    create unique_index(:users, [:email])
  end
end
