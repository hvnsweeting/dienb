# TODO: use new inline-mix feature to auto install deps
{parsed, args, invalid} = OptionParser.parse(System.argv,
  aliases: [c: :concurrency, n: :requests],
  strict: [concurrency: :integer, requests: :integer]
)
if args == [] do
  IO.puts("URL is missing")
  exit({:shutdown, 1})
end


if invalid != [] do
  IO.inspect(invalid, label: "bad arguments")
  exit({:shutdown, 1})
end

[url|_] = args
concurrency = Keyword.get(parsed, :concurrency, 70)
requests = Keyword.get(parsed, :requests, 10_000)
Dbien.bench(url, concurrency, requests)
