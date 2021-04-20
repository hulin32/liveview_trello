defmodule LiveviewTrello.Repo.Migrations.CreateUpdateUserIndex do
  use Ecto.Migration

  def change do
    rename table(:users), :crypted_password, to: :encrypted_password

    create unique_index(:users, [:email])
  end
end
