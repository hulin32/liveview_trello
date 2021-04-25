defmodule LiveviewTrello.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveviewTrello.{Board, UserBoard}

  @derive {Jason.Encoder, only: [:id, :password, :password_confirmation, :email, :first_name, :last_name, :encrypted_password]}
  schema "users" do
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :email, :string
    field :first_name, :string
    field :last_name, :string

    has_many :owned_boards, Board
    has_many :user_boards, UserBoard
    has_many :boards, through: [:user_boards, :board]

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :password, :password_confirmation])
    |> validate_required([:first_name, :last_name, :email, :password, :password_confirmation])
    |> validate_format(:email, ~r/@/)
    |> validate_confirmation(:password)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> put_pass_hash()
  end

  def login_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 6)
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :encrypted_password, Pbkdf2.hash_pwd_salt(pass))
      _ ->
        changeset
    end
  end
end
