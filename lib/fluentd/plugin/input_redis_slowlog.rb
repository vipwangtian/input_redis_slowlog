require 'fluent/plugin/input'

module Fluent::Plugin
  class Redis_SlowlogInput < Input
    Fluent::Plugin.register_input('redis_slowlog', self)

    config_param :tag,      :string
    config_param :host,     :string,  :default => nil
    config_param :port,     :integer, :default => 6379
    config_param :logsize,  :integer,  :default => 128
    config_param :interval, :integer,  :default => 10


    def initialize
      super
      require 'redis'
    end

    def configure(conf)
      super
      @get_interval = @interval
    end

    def start
      super
      log.info "start method" << @id
      @redis = Redis.new(
        :host => @host, 
        :port => @port,
        :thread_safe => true
      )
      pong = @redis.ping
      begin
          unless pong == 'PONG'
              raise "input-redis-slowlog: cannot connect redis"
          end
      end
      @watcher = Thread.new(&method(:watch))
    end

    def shutdown
      super
      @redis.quit
    end

    private
    def watch
      while true
        sleep @get_interval
        begin
          output()
        rescue Exception => e
          log.info e
        end
      end
    end

    def output()
      slow_logs = []
      slow_logs = @redis.slowlog 'get', logsize
      log.info slow_logs.size.to_s
      if slow_logs.size > 0
        @redis.slowlog 'reset'
        log_id = slow_logs[0][0]
        es = Fluent::MultiEventStream.new
        slow_logs.reverse.each do |log_item|
          log_hash = { id: log_item[0], timestamp: Time.at(log_item[1]), exec_time: log_item[2], command: log_item[3] }
          es.add(Fluent::Engine.now, log_hash)
        end
        router.emit_stream(tag, es)
      end
    end
  end
end
