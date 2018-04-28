# input_redis_slowlog
a fluentd input plugin for redis slowlog
## installation
* fluentd must be installed before install this
* download gem file from release
```txt
td-agent-gem install redis
td-agent-gem install --local input_redis_slowlog.gem
```
## config example
```txt
<source>
  @type redis_slowlog
  @id redis.slowlog.1
  @label slowlog
  host [your redis host]
  port [your redis port]
  logsize  [get logsize default 128]
  interval [get log interval default 10]
  tag redis.slowlog.xxx
</source>
<label slowlog>
  <match redis.slowlog.*>
    @type file
    append true
    path /var/log/redis_slowlog/%Y%m%d/${tag}
    <buffer tag,time>
      flush_mode interval
      timekey 1d
    </buffer>
  </match>
</label>
```
