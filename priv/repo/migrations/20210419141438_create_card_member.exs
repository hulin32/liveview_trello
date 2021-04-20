defmodule LiveviewTrello.Repo.Migrations.CreateCardMembers do
  use Ecto.Migration

  def change do
    create table(:card_members) do
      add :card_id, references(:cards, on_delete: :delete_all), null: false
      add :user_boards_id, references(:user_boards, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:card_members, [:card_id])
    create index(:card_members, [:user_boards_id])
    create unique_index(:card_members, [:card_id, :user_boards_id])

  end
end
