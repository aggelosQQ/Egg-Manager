require 'discordrb'

token = File.read 'token.txt'
CLIENT_ID = 341302744222531594
version = '1.1'

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
user = user[2..-2]
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

bot.command(:ping) do |event|
        now = Time.now
        timestamp = event.timestamp
        diff = (now - timestamp) / 1_000_000
        event.channel.send_embed do |embed|
            embed.title = 'Egg Manager Ping'
            embed.description = "I ain't gone, but I'm pinging in **#{diff}** ms.. is that good?"
            embed.color = 1_151_202
        end
end

bot.command(:mnpn) do |event|
    event.channel.send_embed do |embed|
        embed.title = 'Mnpn Support Discord'
        embed.description = "Join it: **https://discord.gg/Ww74Xjh**"
        embed.color = 1_151_202
    end
end


bot.member_join do |event|
	event.user.add_role(340470911910281216)
end

bot.command(:team, min_args: 1, max_args: 1) do |event, args|
	begin
		event.message.delete
			begin # First of all, remove roles.
				if args == "hard-boiled" || args == "soft-boiled"
					if event.user.roles.include?(340169246774525952) # Hard
						event.user.remove_role(340169246774525952) # Hard
					end
					if event.user.roles.include?(340174198330621952) # Soft
						event.user.remove_role(340174198330621952) # Soft
					end
					if event.user.roles.include?(340470911910281216) # Regular Egg
						event.user.remove_role(340470911910281216) # Regular Egg
					end
				else # The argument was invalid.
					event.respond "I couldn't find that team."
				end
			rescue
				event.respond "I couldn't remove roles."
			end
		if args == "hard-boiled"
			event.user.add_role(340169246774525952) # Hard
			event.user.pm "You have been added to the team of Hard Boiled Eggs :egg:"
		elsif args == "soft-boiled"
			event.user.add_role(340174198330621952) # Soft
			event.user.pm "You have been added to the team of Soft Boiled Eggs :egg:"
		else
			event.respond "I couldn't find that team."	
		end
	rescue
		event.respond "I couldn't add you to the team, I might not have enough permission."
	end
end

trap('INT') do
    exit
end

bot.run 
