# Workload

Distribute simple tasks to multiple threads with ease.

This is an dead simple implementation of multithreaded [producer-consumer](http://en.wikipedia.org/wiki/Producer%E2%80%93consumer_problem) pattern we at [Monterail](http://monterail.com/) are using quite often during imports/exports and all sort of data migration between systems. I'm just tired of writing all that again and again so that's why I put that into a 80LOC gem.


![Schema](https://dl.dropboxusercontent.com/s/8dfzs3k2qajcico/2013-10-25%20at%2012.12%20AM.png)

Each `producer` and `consumer` instance gets it's own thread.

## Installation

```bash
$ gem install workload
```

## Usage

Let's say we have some big file that we need to read and then do something
with every line of that file and that processing can be done in parallel.

```ruby
# job.rb
require "rubygems"
require "workload"

Workload.run do |w|
  w.produce(1) do |queue|       # 1 is the default number of producer threads
    while line = STDIN.gets
      queue << line             # The pipe is simple ruby Queue
    end
  end

  w.consume(5) do |line|        # Here we are spawning 5 consumer threads
    print "[#{Thread.current[:id]}] consuming line: #{line}"
    # do something useful with that input
  end
end
```

and then just run

```
$ cat huge-file.txt | ruby job.rb
```

## FAQ

- What about distributing using sidekiq (or any other queue)?
  - It's too much for such simple task and usually requires some storage (e.g. redis)

- So why not celluloid?
  - It's also too big and complicated

- What about thread safety?
  - There is none. I mean, ruby's [Queue](http://ruby-doc.org/stdlib-2.0.0/libdoc/thread/rdoc/Queue.html) is thread safe and all that but if you use some global state inside `produce` or `consume` blocks than you gonna have a bad time.

- Error handling?
  - If something bad happen inside `consume` block it will be recorded and all errors will be displayed at the end of execution


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
