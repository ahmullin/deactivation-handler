# this class is responsible for all communication with the Podio API
class Adapter

  def initialize
    self.authenticate
  end

  def authenticate
    client = Podio.setup(:api_key => ENV["API_KEY"], :api_secret => ENV["API_SECRET"])
    Podio.client.authenticate_with_credentials(ENV["USERNAME"], ENV["PASSWORD"])
  end

  def authenticate
    id = "PODIO_CLIENT_ID"
    secret = "PODIO_CLIENT_SECRET"
    username = "PODIO_USERNAME"
    pw = "PODIO_PW"
    client = Podio.setup(:api_key => ENV[id], :api_secret => ENV[secret])
    authenticate = Podio.client.authenticate_with_credentials(ENV[username], ENV[pw])
  end

end
