defmodule Extic.Board do
  use GenServer

  @wins [
    # horizontal
    [0,1,2], [3,4,5],[6,7,8],
    # vertical
    [0,3,6], [1,4,7],[2,5,8],
    # diagonal
    [0,4,8], [2,4,6]
  ]
  @board [
    0,1,2,
    3,4,5,
    6,7,8
  ]

  def start_link do
    GenServer.start_link(__MODULE__, @board)
  end

  def draw?(pid) do
    GenServer.call(pid, :draw?)
  end

  def pick(pid, move, letter) do
    GenServer.call(pid, {:pick, move, letter})
  end

  def state(pid) do
    GenServer.call(pid, :state)
  end

  def win?(pid) do
    GenServer.call(pid, :win?)
  end

  def reset(pid) do
    GenServer.call(pid, :reset)
  end

  ## Server Callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_call(:state, _from, board) do
    {:reply, board, board}
  end

  def handle_call(:draw?, _from, board) do
    result = Enum.all?(board, fn (x) -> Kernel.is_bitstring(x) end)
    {:reply, result, board}
  end

  def handle_call({ :pick, move, letter }, _from, board) do
    case Enum.at(board, move) do
      x when Kernel.is_bitstring(x) ->
        {:reply, :error, board}
      _ ->
        new_board = List.replace_at(board, move, letter)
        {:reply, :ok, new_board}
    end
  end

  def handle_call(:win?, _from, board) do
    {:reply, _pwin?(board), board}
  end

  def handle_call(:reset, _from, _board) do
    {:reply, :ok, @board}
  end

  def _pwin?(board) do
    Enum.any? @wins, fn (combo) ->
      [a, b, c] = combo
      case [Enum.at(board, a),Enum.at(board, b),Enum.at(board, c)] do
        [x,x,x] -> # same value
          true
        _ ->
          false
      end
    end
  end

end
