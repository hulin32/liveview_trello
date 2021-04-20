defmodule LiveviewTrello.Board do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveviewTrello.Accounts.User

  schema "boards" do
    field :name, :string
    field :slug, :string

    belongs_to :user, User
    has_many :lists, LiveviewTrello.List
    has_many :cards, through: [:lists, :cards]
    has_many :user_boards, LiveviewTrello.UserBoard

    timestamps()
  end

  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name, :slug, :user_id])
    |> validate_required([:name, :slug, :user_id])
  end
end
