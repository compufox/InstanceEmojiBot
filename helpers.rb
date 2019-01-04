require 'net/http'
require 'json'

EmojiEndpoint = '/api/v1/custom_emojis'
InstanceEndpoint = '/api/v1/instance'
InstanceSave = 'instances.json'
DownloadDir = '/tmp/'

# regex here in case the one i've written doesn't work
# ([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:\/~+#-]*[\w@?^=%&\/~+#-])?
InstanceRegex = /(?<inst>([\w-]+\.)+[\w-]+)/i


# this function should check after a while and make sure our
#  cached emoji list is up-to-date.
#
# maybe a timestamp in the json, if it's a certain amount old
#  we refresh?
def get_emoji_list instance
  loaded_emoji = load_emoji_list instance

  if loaded_emoji.nil?
    loaded_emoji = JSON.parse(
      Net::HTTP.get(
        URI.parse("https://#{instance}#{EmojiEndpoint}"))) 

    save_emoji_list instance, loaded_emoji
  end

  loaded_emoji
end

def get_emoji emoji
  path = "#{DownloadDir}#{emoji['shortcode']}.png"
  File.write(path,
             Net::HTTP.get(URI.parse(emoji['url'])))
  path
end

def check_if_instance instance
  begin
    not JSON.parse(
          Net::HTTP.get(
            URI.parse("https://#{instance}#{InstanceEndpoint}")
          )
        )['description'].empty?
  rescue
    false
  end
end

def save_instance_list list
  File.write(InstanceSave,
             JSON.generate(list))
end

def load_instance_list
  JSON.parse(File.read(InstanceSave)) if File.exists? InstanceSave
end

def save_emoji_list instance, emojis
  File.write("#{instance}.emoji",
             JSON.generate(emojis))
end

def load_emoji_list instance
  instFile = "#{instance}.emoji"
  if File.exists? instFile
    return JSON.parse(File.read(instFile))
  else
    return nil
  end
end
