defmodule LiveviewTrello.CardMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "card_members" do
    belongs_to :card, LiveviewTrello.Card
    belongs_to :user_boards, LiveviewTrello.UserBoard
    has_one :user, through: [:user_boards, :user]
    timestamps()
  end

  @doc false
  def changeset(card_member, attrs) do
    card_member
    |> cast(attrs, [:card_id, :user_id])
    |> validate_required([:card_id, :user_id])
  end
end
