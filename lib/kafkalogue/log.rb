require 'poseidon'

module Kafkalogue
  class Log
    PRODUCER_NAME = "kafkalogue"

    def initialize(brokers:, topic:)
      @producer = Poseidon::Producer.new(brokers, PRODUCER_NAME, {
        compression_codec: :snappy
      })

      @topic = topic
      @buffer = []
    end

    def write(data, key:)
      @buffer << Poseidon::MessageToSend.new(@topic, data, key.to_s)
    end

    def flush
      @producer.send_messages(@buffer)
      @buffer.clear
    end
  end
end
