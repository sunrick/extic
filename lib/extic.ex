defmodule Extic.Tic do
  alias Extic.Board

  def play do
    { :ok, board } = Board.start_link()
    play(board, "X")
  end

  def play(board, player) do
    display_board(board)
    pick = get_pick(player)
    update_board(board, pick, player)
    case [Board.win?(board), Board.draw?(board)] do
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
    if Board.pick(board, pick, player) == :error do
      IO.puts "That move is already taken.\n"
      update_board(board, get_pick(player), player)
    end
  end

  def display_board(board) do
    board = Board.state(board)
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
