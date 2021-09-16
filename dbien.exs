# TODO: use new inline-mix feature to auto install deps
{parsed, _args, invalid} = OptionParser.parse(System.argv,
  aliases: [c: :concurrency, n: :requests],
  strict: [concurrency: :integer, requests: :integer]
)

if invalid != [] do
  IO.inspect(invalid, label: "bad arguments")
  exit({:shutdown, 1})
end

#IO.inspect({parsed, args, invalid}, label: "parsed")

concurrency = Keyword.get(parsed, :concurrency, 70)
requests = Keyword.get(parsed, :requests, 10_000)
Dbien.bench(concurrency, requests)
