require 'net/http'
require 'json'

EmojiEndpoint = '/api/v1/custom_emojis'
InstanceEndpoint = '/api/v1/instance'
InstanceSave = 'instances.json'
DownloadDir = '/tmp/'

def get_emoji_list instance
  JSON.parse(
    Net::HTTP.get(
      URI.parse("https://#{instance}#{EmojiEndpoint}")))
end

def get_emoji emoji
  path = "#{DownloadDir}#{emoji['shortcode']}.png"
  File.write(path,
             Net::HTTP.get(URI.parse(emoji['url'])))
  path
end

def check_if_instance instance
  not Net::HTTP.get(URI.parse("https://#{instance}#{InstanceEndpoint}")).empty?
end

def save_instance_list list
  File.write(InstanceSave,
             JSON.generate(list))
end

def load_instance_list
  known_instances = JSON.parse(File.read(InstanceSave)) if File.exists? InstanceSave
end
