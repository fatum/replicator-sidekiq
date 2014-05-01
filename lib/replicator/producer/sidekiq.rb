require 'replicator/producer'
require 'sidekiq'

module Replicator
  class Producer
    class Sidekiq
      def initialize(collection, consumers)
        @collection, @consumers = collection, consumers
      end

      def call(action, state)
        @consumers.each do |c|
          ::Sidekiq::Client.
            push(
              'class' => 'Replicator::Sidekiq::Worker',
              'args' => [action, state],
              'queue' => "#{@collection}_#{c}")
        end
      end
    end
  end
end