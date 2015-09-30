require 'spec_helper'
require 'active_support/notifications'

describe Kafkalogue do
  let(:kafka_brokers) { ENV.fetch("KAFKA_BROKERS").split(",") }
  let(:log) { Kafkalogue.new(brokers: kafka_brokers, topic: "test") }
  let(:events) { [] }
  let(:subscriber) { -> (*args) { events << ActiveSupport::Notifications::Event.new(*args) } }

  before do
    ActiveSupport::Notifications.subscribe(/.+\.kafkalogue/, subscriber)
  end

  it "writes log entries" do
    log.write("some data", key: "yolo")
    log.flush
  end

  it "instruments buffer overflows" do
    Kafkalogue::MAX_BUFFER_SIZE.times do
      log.write("yolo", key: "xoxo")
    end

    expect(events).to be_empty

    log.write("hey", key: "you")

    expect(events.size).to eq 1
    expect(events.first.name).to eq "buffer_overflow.kafkalogue"
    expect(events.first.payload.fetch(:topic)).to eq "test"
  end

  it "instruments failure to flush the buffer" do
    log = Kafkalogue.new(brokers: ["yolo"], topic: "test")

    log.write("yolo", key: "xoxo")
    log.flush

    expect(events.size).to eq 1
    expect(events.first.name).to eq "flush_failed.kafkalogue"
  end
end
