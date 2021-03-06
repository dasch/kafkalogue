require 'poseidon'

module Kafkalogue
  PRODUCER_NAME = "kafkalogue"
  MAX_BUFFER_SIZE = 5000

  class Log
    def initialize(brokers:, topic:)
      @producer = Poseidon::Producer.new(brokers, PRODUCER_NAME, {
        compression_codec: :snappy
      })

      @topic = topic
      @buffer = []
    end

    def write(data, key:)
      if @buffer.size < MAX_BUFFER_SIZE
        @buffer << Poseidon::MessageToSend.new(@topic, data, key.to_s)
      else
        instrument :buffer_overflow
      end
    end

    def flush
      instrument :flush do
        @producer.send_messages(@buffer)
      end

      @buffer.clear
    rescue Poseidon::Errors::UnableToFetchMetadata, SocketError
      # Couldn't write to Kafka, so let's just buffer the messages for now.
    end

    private

    def instrument(event, payload = {}, &block)
      if defined?(ActiveSupport::Notifications)
        key = "#{event}.kafkalogue"
        payload[:topic] = @topic
        ActiveSupport::Notifications.instrument(key, payload, &block)
      end
    end
  end
end
