module Replicator
  class Consumer
    class Sidekiq
      def initialize(collection)
        @collection = collection
      end

      def call(consumer)
      end
    end
  end
end