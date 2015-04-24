require 'twitter'

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = "CK"
  config.consumer_secret     = "CS"
  config.access_token        = "AT"
  config.access_token_secret = "ATS"
end

client.update(File.open("tweet.json") if File.open("tweet.json") != "")
