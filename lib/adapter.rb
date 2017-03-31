# this class is responsible for all communication with the Podio API
class Adapter

  def initialize
    self.authenticate
  end

  def authenticate
    id = "PODIO_CLIENT_ID"
    secret = "PODIO_CLIENT_SECRET"
    username = "PODIO_USERNAME"
    pw = "PODIO_PW"
    client = Podio.setup(:api_key => ENV[id], :api_secret => ENV[secret])
    authenticate = Podio.client.authenticate_with_credentials(ENV[username], ENV[pw])
  end

  def get_field_id(field_name)
    case field_name
    when "Previous Roles in Government"
      return 129664962
    when "Reports to Person"
      return 129664963
    when "Works for Group"
      return 129664964
    when "Personal Staff Office"
      return 129664965
    when "Email"
      return 129664971
    when "Email 2"
      return 129664972
    when "Phone 1 / District Office"
      return 129664973
    when "Phone 2 / Capitol or Legislative Office"
      return 129664974
    when "Phone 3 / Other"
      return 129664975
    when "Fax 1 / District Office"
      return 129664976
    when "Fax 2 / Capital or Legislative Office"
      return 129664977
    when "Address 1 / District Office"
      return 129664978
    when "Address 2 / Capitol or Legislative Office"
      return 129664979
    when "Address 3 / Other"
      return 129664980
    when "Reason"
      return 129664985
    when "Government Body"
      return 129664986
    when "Legislative Staff Type"
      return 129664989
    when "Personal Staff Responsibility"
      return 129664990
    when "Active"
      return 129665007
    when "Title"
      return 129665005
    end
  end

  def find_item(item_id)
    Podio::Item.find(item_id)
  end


  def update_field(item_id, field_id, new_value)
    # Podio::ItemField.update( item_id, field_id, new_value )
  end


end
