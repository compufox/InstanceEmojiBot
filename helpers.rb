require 'net/http'
require 'json'

EmojiEndpoint = '/api/v1/custom_emojis'

def get_emoji_list instance
  JSON.parse(
    Net::HTTP.get(
      URI.parse(instance + EmojiEndpoint)))
end
