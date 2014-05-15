require 'replicator/sidekiq/worker'

module Replicator
  class Consumer
    class Sidekiq
      def initialize(collection)
        @collection = collection
      end

      def call(consumer)
        Replicator::Sidekiq::Worker.create consumer
      end
    end
  end
end