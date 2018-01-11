  module V1
    module MediaTypes
      class Mail < Praxis::MediaType

        identifier 'application/json'

        attributes do
          attribute :message_id, String
          attribute :message, String
        end

        view :default do
          attribute :message, example: 'Queued. Thank you.'
          attribute :message_id, example: "<20180111191946.1.50D7896597E97DC2@example.com>"
        end
      end
    end
  end
