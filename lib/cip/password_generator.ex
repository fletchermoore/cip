defmodule Cip.PasswordGenerator do
  # alphanumeric except 0, O, I, l, 1, 2, Z for clarity
  # @chars "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz23456789" |> String.split("")
  @chars "ABCDEFGHJKLMNPQRSTUVWXY3456789" |> String.split("")

  def random(length) do
    Enum.reduce((1..length), [], fn (_i, acc) ->
      [Enum.random(@chars) | acc]
    end) |> Enum.join("")
  end
end
