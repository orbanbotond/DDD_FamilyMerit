module Exercising
  module Handstand
	  module Events
	    class HandstandPracticeStarted < ::Infra::Event
	      attribute :user_id, Infra::Types::Strict::String
	    end
	    class HandstandSetupSucceeded < ::Infra::Event
	      attribute :time, Infra::Types::Strict::Integer
	      attribute :reason, Infra::Types::Strict::String
	      attribute :user_id, Infra::Types::Strict::String
	    end
	    class HandstandSetupFailed < ::Infra::Event
	      attribute :time, Infra::Types::Strict::Integer
	      attribute :reason, Infra::Types::Strict::String
	      attribute :user_id, Infra::Types::Strict::String
	    end
	    class HandstandSucceeded < ::Infra::Event
	      attribute :time, Infra::Types::Strict::Integer
	      attribute :reason, Infra::Types::Strict::String
	      attribute :user_id, Infra::Types::Strict::String
	      attribute :consecutive, Infra::Types::Strict::Integer
	    end
	    class HandstandFailed < ::Infra::Event
	      attribute :time, Infra::Types::Strict::Integer
	      attribute :reason, Infra::Types::Strict::String
	      attribute :user_id, Infra::Types::Strict::String
	    end
	    class HandstandPracticeProgressed < ::Infra::Event
	      attribute :reason, Infra::Types::Strict::String
	      attribute :user_id, Infra::Types::Strict::String
	      attribute :progression, Infra::Types::Strict::Integer
	    end
	    class HandstandPracticeRegressed < ::Infra::Event
	      attribute :reason, Infra::Types::Strict::String
	      attribute :user_id, Infra::Types::Strict::String
	    end
	    class HandstandPracticeFinished < ::Infra::Event
	      attribute :reason, Infra::Types::Strict::String
	      attribute :user_id, Infra::Types::Strict::String
	    end
	  end
  end
end
