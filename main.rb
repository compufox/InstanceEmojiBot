require 'elephrame'
require_relative 'helpers'

EmojiBot = Elephrame::Bots::PeriodicInteract.new '4h'


# if someone @s us with an instance name
EmojiBot.on_reply do |bot|
  
end


# select a random instance from a db(?) from followers(????)
EmojiBot.run do |bot|
  
end
