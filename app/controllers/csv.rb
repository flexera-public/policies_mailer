require 'tempfile'
require 'csv'
require 'securerandom'

module V1
  class CSVAPI
    include Praxis::Controller

    implements V1::ApiResources::CSVAPI
    TEMP_FILE_DIR = Praxis::Application.instance.config.temp_file_directory
    def self.delete(id)
      File.delete(File.join(TEMP_FILE_DIR,id)) if File.exist?(File.join(TEMP_FILE_DIR,id))
    end

    def index(**params)
      response.headers['Content-Type'] = 'application/json'
      response.body = 'CSV Page'.to_json
      response
    end

    def show(id:, **other_params)
      file = File.join(TEMP_FILE_DIR, id)
      arr_of_arrs = CSV.read(file)
      response.headers['Content-Type'] = 'application/json'
      response.body = arr_of_arrs.to_json
      response
    end

    def create()
      file_id = "#{SecureRandom.uuid}.csv"
      payload = request.payload.contents
      data = payload[:data]
      file = File.open(File.join(TEMP_FILE_DIR,file_id),'w+'){ |f| f << data.map(&:to_csv).join }
      response.headers['Content-Type'] = 'application/json'
      response.body = { file: File.basename(file.path) }.to_json
      response
    end

    def update(id:, **other_params)
      payload = request.payload.contents
      data = payload[:data]
      file = File.open(File.join(TEMP_FILE_DIR,id),'a+'){ |f| f << data.map(&:to_csv).join }
      response.headers['Content-Type'] = 'application/json'
      response.body = { file: File.basename(file.path) }.to_json
      response
    end

    def delete(id:, **other_params)
      self.class.delete(id)
      response.headers['Content-Type'] = 'application/json'
      response
    end
  end
end
