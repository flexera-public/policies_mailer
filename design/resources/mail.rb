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
          attribute :to, String, required: true, description: 'email to:', example: 'john.doe@example.com'
          attribute :from, String, required: true, description: 'email from:', example: 'mary.doe@example.com'
          attribute :subject, String, required: true, description: 'email subject'
          attribute :body, String, required: true, description: 'content of the email'
          attribute :attachment, String, required: false, description: 'file name to be attached', example: '6901f064-8077-4644-984b-a3ee258f57c3.csv'
          attribute :encoding, String, required: false, default: 'text', values: ['text','html'], example: 'text'
          attribute :delete_attachment, Attributor::Boolean, required: false, default: true
        end
      end
    end
  end
end
