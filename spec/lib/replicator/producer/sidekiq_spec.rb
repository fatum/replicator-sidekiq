require 'spec_helper'

describe 'Sidekiq producer' do
  class SidekiqProducer
    include Replicator::Producer::Mixin

    produce :collection do
      consumers :test
      adapter :sidekiq
    end

    def initialize(state)
      @state = state
    end

    def update(state)
      @state.merge!(state)

      producer.sync :update, state
    end
  end

  before do
    p = SidekiqProducer.new(id: 2)
    p.update(id: 2)
  end

  specify {  }
end