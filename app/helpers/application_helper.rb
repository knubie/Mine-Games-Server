module ApplicationHelper
  def broadcast(channel, json)
    message = {:channel => channel, :data => json}
    uri = URI.parse("http://mine-games-faye.herokuapp.com/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
end
