require "replicator/sidekiq/version"

require 'sidekiq'
require 'replicator'

require 'replicator/consumer/sidekiq'
require 'replicator/producer/sidekiq'

module Replicator
  module Sidekiq
    def setup
      Replicator.consumers.each do |name, consumer|
        p "Setup consumer: #{name}"
        consumer.receiving
      end
    end

    module_function :setup
  end
end
