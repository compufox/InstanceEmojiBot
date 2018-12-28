require 'elephrame'
require_relative 'helpers'

EmojiBot = Elephrame::Bots::PeriodInteract.new '3h'
known_instances =  [ 'botsin.space', 'social.computerfox.xyz',
                     'glaceon.social', 'cybre.space', 'trollian.space',
                     'queer.party', 'donphan.social', 'sleeping.town',
                     'vulpine.club', 'yiff.life', 'lamp.institute',
                     'berries.space', 'computerfairi.es', 'chomp.life'
                  ]

# load instances we have saved
loaded = load_instance_list
known_instances = loaded unless loaded.nil?

def post_emoji(instance, bot, status = nil)
  emojis = get_emoji_list instance
  
  if emojis.empty?
    known_instances.remove! instance
    save_instance_list known_instances
    return false
  end
  
  chosen_emoji = emojis.sample
  epath = get_emoji chosen_emoji

  if status.nil?
    bot.post("#{chosen_emoji['shortcode']} from #{instance}",
             media: [ epath ],
             spoiler: 'emoji',
             hide_media: true,
             visibility: 'public'
            )
  else
    bot.reply("#{chosen_emoji['shortcode']} from #{instance}",
              media: [ epath ],
              spoiler: 'emoji',
              hide_media: true
             )
  end

  File.delete(epath)
end

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
    
    unless post_emoji(instance, bot, status)
      bot.reply("I don't think that instance has any emoji :O")
    end
    
  else
    bot.reply("I don't think that's an instance :/ please check you have the correct domain name and try again!")
  end
end


# select a random instance from a db(?) from followers(????)
EmojiBot.run do |bot|
  posted = false
  while not posted
    instance = known_instances.sample
    post_emoji(instance, bot)
  end
end
