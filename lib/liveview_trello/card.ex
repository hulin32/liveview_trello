defmodule LiveviewTrello.Card do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveviewTrello.{List, Comment, CardMember}

  schema "cards" do
    field :desc, :string
    field :name, :string
    field :order, :integer
    field :tags, :string

    belongs_to :list, List
    has_many :comments, Comment
    has_many :card_members, CardMember
    has_many :members, through: [:card_members, :user]

    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:name, :list_id, :desc, :order, :tags])
    |> validate_required([:name, :list_id, :desc, :order, :tags])
  end
end
