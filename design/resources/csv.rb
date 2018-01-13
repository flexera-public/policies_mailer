module V1
  module ApiResources
    class CSVAPI
      include Praxis::ResourceDefinition

      media_type V1::MediaTypes::CSVAPI
      version '1.0'

      prefix '/api/csv'

      # Will apply to all actions of this resource

      action_defaults do
        response :ok
      end

      action :index do

        routing do
          get ''
        end
      end

      action :show do

        routing do
          get '/:id'
        end
        params do
          attribute :id, String, required: true, example: '6901f064-8077-4644-984b-a3ee258f57c3.csv'
        end
        response :not_found
      end

      action :create do
        routing do
          post ''
        end
        payload do
          attribute :data, Attributor::Collection, required: false, example: [['column-a', 'column-b']]
        end
        response :created
      end

      action :update do
        routing do
          put '/:id'
          patch '/:id'
        end

        params do
          attribute :id, String, required: true, example: '6901f064-8077-4644-984b-a3ee258f57c3.csv'
        end

        payload do
          attribute :data, Attributor::Collection, required: true, example: [['row-item-1', 'row-item-2']]
        end
        response :created
      end

      action :delete do
        routing do
          delete '/:id'
        end

        params do
          attribute :id, String, required: true, example: '6901f064-8077-4644-984b-a3ee258f57c3.csv'
        end
        response :no_content
      end
    end
  end
end
