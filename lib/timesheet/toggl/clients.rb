module Timesheet
  module Clients
    CLIENTS_URI = 'https://api.track.toggl.com/api/v8/clients'

    def create_client(name, workspace_id)
      params = {
        client: {
          name: name,
          wid: workspace_id,
        }
      }
      headers = {}
      headers['Content-Type']='application/json'
      headers['X-Requested-With']='XMLHttpRequest'
      headers['Accept']='application/json'
      response = Curl::Easy.http_post(CLIENTS_URI, params.to_json) do |request|
        request.http_auth_types = :basic
        request.username = config[:api_token]
        request.password = 'api_token'
        request.headers = headers
      end
      if response.response_code == 200
        JSON.parse(response.body, symbolize_names: true)[:data][:id]
      else
        Rails.logger.error "Client creation failed: #{response.body}"
      end
    end
  end
end
