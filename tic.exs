defmodule Tic do

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

  def play do
    play(@board, "X")
  end
  def play(board, player) when is_list(board) do
    display_board(board)
    pick = get_pick(player)
    board = update_board(board, pick, player)
    case [win?(board), draw?(board)] do
      [true, _] ->
        display_board(board)
        IO.puts "You win #{player}!"
        if play_again?(), do: play()
      [_, true] ->
        display_board(board)
        IO.puts "Draw!"
        if play_again?(), do: play()
      _ ->
        play(board, switch_player(player))
    end
  end

  def play_again? do
    IO.gets("\nPlay again? Y/N \n") |> String.trim |> String.downcase == "y"
  end

  def get_pick(player) do
    { int, _ } = IO.gets("Pick a move #{player}:\n")
      |> String.trim
      |> Integer.parse
    int - 1
  end

  def update_board(board, pick, player) do
    case Enum.at(board, pick) do
      x when Kernel.is_bitstring(x) ->
        IO.puts "That move is already taken.\n"
        update_board(board, get_pick(player), player)
      _ ->
        List.replace_at(board, pick, player)
    end
  end

  def win?(board) do
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

  def draw?(board) do
    Enum.all?(board, fn (x) -> Kernel.is_bitstring(x) end)
  end

  def display_board(board) do
    IO.puts ""
    Enum.map(board, fn (x) -> if Kernel.is_integer(x), do: x + 1, else: x end)
    |> Enum.chunk(3)
    |> Enum.map(fn (chunk) -> Enum.join(chunk, ",") |> IO.puts end)
    IO.puts ""
  end

  def switch_player(player) do
    if player == "X", do: "O", else: "X"
  end

end

Tic.play
