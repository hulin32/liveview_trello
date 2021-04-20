defmodule LiveviewTrello.List do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveviewTrello.{Board, Card}

  schema "lists" do
    field :name, :string

    belongs_to :board, Board
    has_many :cards, Card

    timestamps()
  end

  @doc false
  def changeset(list, attrs) do
    list
    |> cast(attrs, [:board_id, :name])
    |> validate_required([:board_id, :name])
  end
end
