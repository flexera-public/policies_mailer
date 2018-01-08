require 'tempfile'
require 'csv'
require 'pry'

module V1
  class CSVAPI
    include Praxis::Controller

    implements V1::ApiResources::CSVAPI


    def index(**params)
      response.headers['Content-Type'] = 'application/json'
      response.body = 'CSV Page'.to_json
      response
    end

    def show(id:, **other_params)
      if hello
        response.body = { id: id, data: hello }
      else
        self.response = Praxis::Responses::NotFound.new(body: "Hello word with index #{id} not found in our DB")
      end
      response.headers['Content-Type'] = 'application/json'
      response
    end

    def create()
      file = Tempfile.new
      payload = request.payload.contents
      data = payload[:data]
      File.open(file,'w'){ |f| f << data.map(&:to_csv).join }
      response.headers['Content-Type'] = 'application/json'
      response.body = file.path.to_json
      response
    end
  end
end
