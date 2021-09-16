# Dbien

**TODO: Add description**
## Usage

```sh
$ mix run dbien.exs -c 100 -n 10000 http://localhost:8000/fast
Compiling 1 file (.ex)
%{200 => 10000}
3138 ms
Throughput: 3186 RPS
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dbien` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dbien, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/dbien](https://hexdocs.pm/dbien).

