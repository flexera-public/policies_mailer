  module V1
    module MediaTypes
      class Mail < Praxis::MediaType

        identifier 'application/json'

        attributes do
          attribute :string, String
          attribute :message_id, String
          attribute :message, String
        end

        view :default do
          attribute :string
        end

      end
    end
  end
