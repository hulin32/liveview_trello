defmodule LiveviewTrello.UserBoard do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query
  alias LiveviewTrello.Accounts.User
  alias LiveviewTrello.Board

  schema "user_boards" do
    belongs_to :board, Board
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(user_board, attrs) do
    user_board
    |> cast(attrs, [:user_id, :board_id])
    |> validate_required([:user_id, :board_id])
  end

  def get_by(query \\ %LiveviewTrello.UserBoard{}, user_id, board_id) do
    from b in query,
    where: b.user_id == ^user_id,
    where: b.board_id == ^board_id
  end
end
