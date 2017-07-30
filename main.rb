require 'discordrb'

token = File.read 'token.txt'
CLIENT_ID = 341302744222531594
version = '1.0'

bot = Discordrb::Commands::CommandBot.new token: token, client_id: CLIENT_ID, prefix: '.'

bot.ready do |event|
	bot.stream('Join Egg | Community - https://discord.me/cooleggs', 'https://twitch.tv/aggelosqq')
end

bot.command(:help) do |event|
	event.channel.send_embed do |embed|
		embed.title = 'Egg Manager Information'
		embed.description = 'Prefix: ``_``
Info section is under construction.'
		embed.color = 16_722_454
	end
end


bot.command(:egg) do |event|
	event.respond "#{event.user.mention}, you're an egg!"
end



bot.command(:avatar, min_args: 1, max_args: 1) do |event, user|
user = user[2..-1]
user = user.chomp('>')
    begin
        tagged_user = bot.user(user);
        event.respond "#{tagged_user.mention}'s avatar URL is #{tagged_user.avatar_url}"
    rescue
        begin
            user = user[1..-1]
            tagged_user = bot.user(user);
            event.respond "#{tagged_user.mention}'s avatar URL is #{tagged_user.avatar_url}"
        rescue
            event.respond "That's an invalid user."
        end
    end
end

bot.command(:talk) do |event, *args|
	event.message.delete
	event.respond args.join(' ')
end

bot.member_join do |event|
	event.user.add_role(340470911910281216)
end

trap('INT') do
    exit
end

bot.run 