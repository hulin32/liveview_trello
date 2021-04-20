defmodule LiveviewTrello.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :card_id, references(:cards, on_delete: :delete_all), null: false
      add :content, :text

      timestamps()
    end

    create index(:comments, [:user_id])
    create index(:comments, [:card_id])
  end
end
