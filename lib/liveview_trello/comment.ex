defmodule LiveviewTrello.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comments" do
    field :content, :string

    belongs_to :user, LiveviewTrello.Accounts.User
    belongs_to :card, LiveviewTrello.Card

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:user_id, :card_id, :content])
    |> validate_required([:user_id, :card_id, :content])
  end
end
