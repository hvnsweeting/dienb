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

  @doc """
  This factored out to maybe reuse http conn
  """
  def do_get(conn, path) do
    {:ok, conn, _request_ref} = Mint.HTTP.request(conn, "GET", path, [], "")

    receive do
      message ->
        {:ok, _conn, responses} = Mint.HTTP.stream(conn, message)
        [{:status, _, status_code} | _] = responses
        # {:ok, conn, status_code}
        status_code
    end
  end

  def get(url, _n) do
    # parse url
    u = URI.parse(url)

    scheme = case u.scheme do
      "https" -> :https
      "http" -> :http
    end

    {:ok, conn} = Mint.HTTP.connect(scheme, u.host, u.port)
    [do_get(conn, u.path)]
    # {_, r} = 1..n |> Enum.reduce({conn, []}, fn _, {conn, ss} ->
    #    {:ok, conn, status} = do_get(conn)
    #    {conn, [status|ss]}
    # end)
    # r
    # TODO: may need to check how connection closed
  end

  def bench(url, c \\ 70, n \\ 10_000) do
    # TODO allow change URL
    start = System.monotonic_time(:millisecond)
    # TODO how to reuse conn for each task runner
    # create c conns first, then pass it to workers
    1..n
    |> Task.async_stream(fn _i -> Dbien.get(url, div(n, c)) end, max_concurrency: c)
    |> Enum.to_list()
    |> Enum.map(fn {:ok, v} -> v end)
    |> Enum.concat()
    |> Enum.frequencies()
    |> IO.inspect()

    stop = System.monotonic_time(:millisecond)
    duration = stop - start
    IO.puts("#{duration} ms")
    IO.puts("Throughput: #{div(n*1000, duration)} RPS")
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
