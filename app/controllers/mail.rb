require 'mailgun'

module V1
  class Mail
    include Praxis::Controller

    implements V1::ApiResources::Mail

    MAILGUN_DOMAIN = Praxis::Application.instance.config.mailgun_domain
    TEMP_FILE_DIR = Praxis::Application.instance.config.temp_file_directory

    def create()
      mg_client = Mailgun::Client.new Praxis::Application.instance.config.mailgun_api_key
      payload = request.payload.contents
      pp payload
      mb_obj = Mailgun::MessageBuilder.new
      mb_obj.from payload[:from]
      mb_obj.add_recipient :to, payload[:to]
      mb_obj.subject payload[:subject]
      mb_obj.body_text payload[:body] if payload[:encoding] == 'text' || !payload[:encoding]
      mb_obj.boxy_html payload[:body] if payload[:encoding] == 'html'
      if payload[:attachment]
        mb_obj.add_attachment File.join(TEMP_FILE_DIR,payload[:attachment])
        V1::CSVAPI.delete(payload[:attachment]) if payload[:delete_attachment]
      end

      result = mg_client.send_message(MAILGUN_DOMAIN, mb_obj).to_h!

      message_id = result['id']
      message = result['message']
      response.headers['Content-Type'] = 'application/json'
      response.body = { message_id: message_id, message: message }.to_json
      response
    end
  end
end
