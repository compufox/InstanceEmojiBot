require 'elephrame'
require_relative 'helpers'

EmojiBot = Elephrame::Bots::PeriodicInteract.new '4h'
known_instances = [ 'botsin.space', 'social.computerfox.xyz',
                    'glaceon.social', 'cybre.space', 'trollia.space',
                    'queer.party', 'donphan.social', 'sleeping.town',
                    'vulpine.club', 'yiff.life', 'lamp.institute',
                    'berries.space'
                  ]

# load instances we have saved
load_instance_list

# if someone @s us with an instance name
EmojiBot.on_reply do |bot, status|
  instance = status.content
               .sub(/@#{bot.username} /, '')
               .sub(/https?:\/\//, '')
               .strip


  unless known_instances.include?(instance) and check_if_instance(instance)
    known_instances.append(instance)
    
    save_inst_list
  end
end


# select a random instance from a db(?) from followers(????)
EmojiBot.run do |bot|
  instance = known_instances.sample
  emojis = get_emoji_list instance
  chosen_emoji = emojis[emoji.keys[rand(emojis.size)]]
  
  epath = get_emoji chosen_emoji
  bot.post("#{chosen_emoji['shortcode']} from #{instance}",
           media: [ epath ],
           spoiler: 'emoji',
           hide_media: true
          )
end
