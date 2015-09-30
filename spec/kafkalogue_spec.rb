require 'spec_helper'

describe Kafkalogue do
  it "writes log entries" do
    kafka_brokers = ENV.fetch("KAFKA_BROKERS").split(",")
    log = Kafkalogue.new(brokers: kafka_brokers, topic: "test")
    log.write("some data", key: "yolo")
    log.flush
  end
end
