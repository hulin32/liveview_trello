defmodule LiveviewTrello.Card do
  use Ecto.Schema
  import Ecto.Changeset

  alias LiveviewTrello.{List, Comment, CardMember}

  schema "cards" do
    field :desc, :string
    field :name, :string
    field :position, :integer
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
    |> cast(attrs, [:name, :list_id, :desc, :position, :tags])
    |> validate_required([:name, :list_id])
    |> put_position()
  end

  defp put_position(changeset) do
    put_change(changeset, :position, 1)
  end
end
