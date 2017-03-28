# this class is responsible for handling/manipulating data for the Meeting Apps in both workspaces
class DeactivationService

  attr_reader :client

  def initialize
    @client = Adapter.new
    @client.authenticate
  end


end
