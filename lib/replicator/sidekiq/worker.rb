module Replicator
  module Sidekiq
    class Worker
      def self.create(consumer)
        _class = Class.new do
          include ::Sidekiq::Worker
          sidekiq_options queue_name: "replicator-#{consumer.collection}-#{consumer.name}"

          def perform(_consumer, _action, _state)
            packet = Replicator::Packet.new(action: _action, state: _state)
            Replicator.consumers[_consumer.to_sym].process(packet)

            p "Consumed: #{_consumer}: #{_action} - #{_state}"
          end
        end

        Replicator::Sidekiq.const_set("Worker#{consumer.name.to_s.camelcase}", _class)
      end
    end
  end
end