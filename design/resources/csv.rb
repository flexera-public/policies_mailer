module V1
  module ApiResources
    class CSVAPI
      include Praxis::ResourceDefinition

      media_type V1::MediaTypes::Hello
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
          attribute :id, Integer, required: true, min: 0
        end
        response :not_found
      end

      action :create do
        routing do
          post ''
        end
        payload do
          attribute :data, Attributor::Collection, required: false
        end
        response :created
      end
    end
  end
end
