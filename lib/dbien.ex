defmodule Dbien do
  @moduledoc """
  Documentation for `Dbien`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Dbien.hello()
      :world

  """
  def hello do
    :world
  end

  def get do
    {:ok, conn} = Mint.HTTP.connect(:http, "localhost", 8000)
    {:ok, conn, _request_ref} = Mint.HTTP.request(conn, "GET", "/", [], "")
    receive do
      message ->
        {:ok, _conn, responses} = Mint.HTTP.stream(conn, message)
        [{:status, _, status_code}|_] = responses
        status_code
    end
  end

  def bench(n) do
    #TODO allow change URL
    start = System.monotonic_time(:millisecond)
    1..n |> Task.async_stream(fn _i -> Dbien.get() end) |> Enum.to_list
    stop = System.monotonic_time(:millisecond)
    duration = stop - start
    IO.puts("#{duration} ms")
    IO.puts("Throughput: #{n/(duration/1000)} RPS")
    # TODO time each conn to calculate latency
    # TODO how to create 1000 concurrency level???
    # TODO much later, already 2x locust single node
    # TODO improve speed, try to x2,
    # TODO test with ulimit -n65k
    # 4090 ms
    # Throughput: 2444.987775061125 RPS
    #
    # locust baseline 1121

    # hey baseline with hey -n10000
    # Requests/sec: 4528.3071
    #
    # ab base line
    # Concurrency Level:      1000
    # Requests per second:    3706.73 [#/sec] (mean)
  end
end
