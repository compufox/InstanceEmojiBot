require 'elephrame'
require_relative 'helpers'

EmojiBot = Elephrame::Bots::PeriodicInteract.new '4h'
known_instances = [ 'botsin.space', 'social.computerfox.xyz',
                    'glaceon.social', 'cybre.space', 'trollia.space',
                    'queer.party', 'donphan.social', 'sleeping.town',
                    'vulpine.club', 'yiff.life', 'lamp.institute',
                    'berries.space'
                  ]

# if someone @s us with an instance name
EmojiBot.on_reply do |bot|
  
end


# select a random instance from a db(?) from followers(????)
EmojiBot.run do |bot|
  
end
