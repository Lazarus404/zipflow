# zipflow

zipflow is a library for elixir language that allows you to stream the
zip archive while it is being created.

## installation

the package can be installed as:

  1. add zipflow to your list of dependencies in `mix.exs`:

        def deps do
          [{:zipflow, github: "dgvncsz0f/zipflow"}]
        end

## the problem

erlang provides a `:zip` module that can be used to create a zip
archive. however you can not use that to stream the zip file. using
erlang's `:zip` module you only have the option to write to a file or
entirely on memory.

this module solves that problem by streaming the contents of the zip
file while it is being created.

## example

this example writes a zip file to a file:

```
iex> File.open("/path/to/file", [:raw, :binary, :write], fn fh ->
...>   printer = & IO.binwrite(fh, &1)
...>   Zipflow.Stream.init
...>   |> Zipflow.Stream.entry(Zipflow.DataEntry.encode(printer, "foo/bar", "foobar"))
...>   |> Zipflow.Stream.flush(printer)
...> end)
```

Then you should have:

```
$ unzip -l /path/to/file
Archive:  example.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
        6  1980-00-00 00:00   foo/bar
---------                     -------
        6                     1 file
```

another example, this time archiving a file:

```
iex> File.open("/path/to/file", [:read, :raw, :binary], fn fh ->
...>   printer = & IO.binwrite(fh, &1)
...>   Zipflow.Stream.init
...>   |> Zipflow.Stream.entry(Zipflow.FileEntry.encode(printer, "foo/bar", fh))
...>   |> Zipflow.Stream.flush(printer)
...> end)
```

the `FileEntry` consumes the file in chunks so it has a low memory
footprint. However, this is not a zip64 format so the maximum file
size you can archive is 4G.

There is a script you can use for testing. It archives a directory:

```
$ mix escript.build
$ ./zipflow /tmp/zipflow.zip lib/bin
$ unzip -l /tmp/zipflow.zip
Archive:  /tmp/zipflow.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
      301  1980-00-00 00:00   lib/bin/zip.ex
---------                     -------
      301                     1 file
```

## todo

* [ ] encryption;
* [ ] compression;
* [ ] utf encoding;
* [ ] zip64 format;
* [ ] file/archive comments;
* [ ] store date/time correctly;
* [ ] support more than 2^16 files;

## licence

BSD-3

## contributors (thanks!)

* @feymartynov
* @nicholasjhenry
