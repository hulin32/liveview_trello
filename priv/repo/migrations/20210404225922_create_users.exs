defmodule LiveviewTrello.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :email, :string, null: false
      add :crypted_password, :string, null: false

      timestamps()
    end
  end
end
