defmodule LiveviewTrello.CardMember do
  use Ecto.Schema
  import Ecto.Changeset

  schema "card_member" do
    belongs_to :card, LiveviewTrello.Card
    belongs_to :user, LiveviewTrello.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(card_member, attrs) do
    card_member
    |> cast(attrs, [:card_id, :user_id])
    |> validate_required([:card_id, :user_id])
  end
end
