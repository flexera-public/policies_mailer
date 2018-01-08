require 'tempfile'
require 'fastercsv'

module V1
  class CSV
    include Praxis::Controller

    implements V1::ApiResources::CSV


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

    def create(data:, **other_params)
      file = Tempfile.new
      FasterCSV.open(file.path, "w") do |csv|
        csv << data
      end
      response.headers['Content-Type'] = 'application/json'
      response.body = file.path.to_json
      response
    end
  end
end
