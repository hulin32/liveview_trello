defmodule LiveviewTrello.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :name, :string
      add :list_id, references(:lists, on_delete: :delete_all), null: false
      add :desc, :string
      add :position, :integer, default: 0
      add :tags, :string

      timestamps()
    end

    create index(:cards, [:list_id])
  end
end
