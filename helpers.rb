require 'net/http'
require 'json'

EmojiEndpoint = '/api/v1/custom_emojis'
InstanceEndpoint = '/api/v1/instance'
InstanceSave = 'instances.json'
DownloadDir = '/tmp/'

def get_emoji_list instance
  JSON.parse(
    Net::HTTP.get(
      URI.parse(instance + EmojiEndpoint)))
end

def get_emoji emoji
  File.write("#{DownloadDir}#{emoji['shortcode']}.png",
             Net::HTTP.get(URI.parse(emoji['url'])))
end
