# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "input_redis_slowlog"
  spec.version       = "0.1.0"
  spec.authors       = ["vipwangtian"]
  spec.description   = "Redis slowlog input plugin for Fluent event collector"
  spec.summary       = spec.description
  spec.files         = `git ls-files`.split($/)
  spec.require_paths = ["lib"]
end
