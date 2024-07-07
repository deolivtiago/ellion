defmodule EllionCore.Repo.Migrations.CreateCities do
  use Ecto.Migration

  def change do
    create table(:cities, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :state_id, references(:states, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:cities, [:state_id])
  end
end
