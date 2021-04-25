defmodule LiveviewTrello.Board do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias LiveviewTrello.Accounts.User
  alias LiveviewTrello.{List, UserBoard, Comment, Card}

  schema "boards" do
    field :name, :string
    field :slug, :string

    belongs_to :user, User
    has_many :lists, List
    has_many :cards, through: [:lists, :cards]
    has_many :user_boards, UserBoard

    timestamps()
  end

  @doc false
  def changeset(board, attrs) do
    board
    |> cast(attrs, [:name, :user_id])
    |> validate_required([:name, :user_id])
    |> slugify_name()
  end

  def not_owned_by(query \\ %LiveviewTrello.Board{}, user_id) do
    from b in query,
    where: b.user_id != ^user_id
  end

  def preload_all(query) do
    comments_query = from c in Comment, order_by: [desc: c.inserted_at], preload: :user
    cards_query = from c in Card, order_by: c.position, preload: [[comments: ^comments_query]]
    lists_query = from l in List, order_by: l.position, preload: [cards: ^cards_query]

    from b in query, preload: [:user, lists: ^lists_query]
  end

  defp slugify_name(current_changeset) do
    if name = get_change(current_changeset, :name) do
      put_change(current_changeset, :slug, slugify(name))
    else
      current_changeset
    end
  end

  def slug_id(board) do
    "#{board.id}-#{board.slug}"
  end

  defp slugify(value) do
    value
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/, "-")
  end
end
