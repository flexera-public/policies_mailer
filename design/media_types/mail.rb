  module V1
    module MediaTypes
      class Mail < Praxis::MediaType

        identifier 'application/json'

        attributes do
          attribute :message_id, String, example: 'Queued. Thank you.'
          attribute :message, String, example: "<20180111191946.1.50D7896597E97DC2@example.com>"
        end

        view :default do
          attribute :message
          attribute :message_id
        end
      end
    end
  end
