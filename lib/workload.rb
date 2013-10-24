require "workload/version"

module Workload
  class Gen
    DEFAULT_OPTS = {
      :sleep => 0.1
    }.freeze

    def initialize(opts = {}, &block)
      @opts = DEFAULT_OPTS.merge(opts)
      @queue = Queue.new
      @errors = []

      block.call(self)
    end

    def produce(n = 1, &block)
      @producers_num = n
      @produce = block
    end

    def consume(n = 1, &block)
      @consumers_num = n
      @consume = block
    end

    def make_producers
      @producers_num.times.map do |i|
        Thread.new do
          @produce.call(@queue)
        end
      end
    end

    def make_consumers
      @consumers_num.times.map do |i|
        Thread.new(i) do |j|
          Thread.current[:id] = j
          while @keep || !@queue.empty?
            begin
              item = @queue.pop(true)
              @consume.call(item)
            rescue ThreadError => ex
              sleep @opts[:sleep]
            rescue => ex
              print "ERROR: #{item} => #{ex}\n"
              @errors << [item, ex]
            end
          end
        end
      end
    end

    def display_errors
      unless @errors.empty?
        puts "\nErrors:\n"
        @errors.each do |item, ex|
          puts "Item #{item} errored with: #{ex.message}"
          puts ex.backtrace.map {|e| "  #{e}"}.join("\n")
          puts
        end

        exit 1
      end
    end

    def run!
      @keep = true
      @producers = make_producers
      @consumers = make_consumers

      @producers.each(&:join)
      @keep = false
      @consumers.each(&:join)

      display_errors
    end
  end

  def self.run(opts = {}, &block)
    Gen.new(opts, &block).run!
  end
end
