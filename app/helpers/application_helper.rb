module ApplicationHelper
  def broadcast(channel, json)
    message = {:channel => channel, :data => json}
    uri = URI.parse("http://localhost:9292/faye") # TODO: replace with production server
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
end
