require 'spec_helper'
require 'active_support/notifications'

describe Kafkalogue do
  let(:kafka_brokers) { ENV.fetch("KAFKA_BROKERS").split(",") }
  let(:log) { Kafkalogue.new(brokers: kafka_brokers, topic: "test") }

  it "writes log entries" do
    log.write("some data", key: "yolo")
    log.flush
  end

  it "instruments buffer overflows" do
    events = []

    subscriber = -> (*args) do
      events << ActiveSupport::Notifications::Event.new(*args)
    end

    ActiveSupport::Notifications.subscribe("buffer_overflow.kafkalogue", subscriber)

    Kafkalogue::MAX_BUFFER_SIZE.times do
      log.write("yolo", key: "xoxo")
    end

    expect(events).to be_empty

    log.write("hey", key: "you")

    expect(events.size).to eq 1

    event = events.first

    expect(event.payload.fetch(:topic)).to eq "test"
  end
end
