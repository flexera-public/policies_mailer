module V1
  module ApiResources
    class Mail
      include Praxis::ResourceDefinition

      media_type V1::MediaTypes::Mail
      version '1.0'

      prefix '/api/mail'

      # Will apply to all actions of this resource
      trait :authorized

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
          attribute :data, Attributor::Collection, required: true
        end
      end
    end
  end
end
