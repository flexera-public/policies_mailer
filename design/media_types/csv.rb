  module V1
    module MediaTypes
      class CSVAPI < Praxis::MediaType

        identifier 'application/json'

        attributes do
          attribute :string, String
          attribute :data, Attributor::Collection
        end

        view :default do
          attribute :string
        end
      end
    end
  end
