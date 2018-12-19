require 'elephrame'
require_relative 'helpers'

EmojiBot = Elephrame::Bots::PeriodInteract.new '4h'
known_instances =  [ 'botsin.space', 'social.computerfox.xyz',
                     'glaceon.social', 'cybre.space', 'trollian.space',
                     'queer.party', 'donphan.social', 'sleeping.town',
                     'vulpine.club', 'yiff.life', 'lamp.institute',
                     'berries.space', 'computerfairi.es'
                  ]

# load instances we have saved
loaded = load_instance_list
known_instances = loaded unless loaded.nil?

# if someone @s us with an instance name
EmojiBot.on_reply do |bot, status|
  instance = status.content
               .sub(/@#{bot.username} /, '')
               .sub(/https?:\/\//, '')
               .strip
               .match(InstanceRegex)
  unless instance.nil?
    instance = instance['inst']
  end

  if (not instance.nil?) and check_if_instance(instance)
    unless known_instances.include?(instance)
      known_instances.append(instance)
      save_instance_list known_instances
    end
    
    emojis = get_emoji_list instance
    chosen_emoji = emojis.sample
  
    epath = get_emoji chosen_emoji
    bot.reply("#{chosen_emoji['shortcode']} from #{instance}",
             media: [ epath ],
             spoiler: 'emoji',
             hide_media: true
             )

    File.delete(epath)
  else
    bot.reply("I don't think that's an instance :/ please check you have the correct domain name and try again!")
  end
end


# select a random instance from a db(?) from followers(????)
EmojiBot.run do |bot|
  instance = known_instances.sample
  emojis = get_emoji_list instance
  chosen_emoji = emojis.sample
  
  epath = get_emoji chosen_emoji
  bot.post("#{chosen_emoji['shortcode']} from #{instance}",
           media: [ epath ],
           spoiler: 'emoji',
           hide_media: true
          )

  File.delete(epath)
end
