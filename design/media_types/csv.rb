  module V1
    module MediaTypes
      class CSVAPI < Praxis::MediaType

        identifier 'application/json'

        attributes do
          attribute :file, String
        end

        view :default do
          attribute :file, example: '6901f064-8077-4644-984b-a3ee258f57c3.csv'
        end
      end
    end
  end
