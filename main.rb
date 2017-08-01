require 'discordrb'

token = File.read 'token.txt'
CLIENT_ID = 341302744222531594
version = '1.2'

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

bot.command(:team, usage: ".team hard-boiled | soft-boiled") do |event, *args|
	if args.length == 0 || args.length > 1
		event.respond "Usage: `.team hard-boiled | soft-boiled`"
		next
	end
	if event.channel.private?
		event.respond "I can't do that in DMs.. Here's an empathy egg: :egg:"
		next
	end
	if event.channel.id == 340175912391802880 || event.channel.id == 341297868818350090
		begin
			begin # First of all, remove roles.
				if args.sample == "hard-boiled" || args.sample == "soft-boiled"
					if event.user.roles.include?(340169246774525952) # Hard
						event.user.remove_role(340169246774525952) # Hard
					end
					if event.user.roles.include?(340174198330621952) # Soft
						event.user.remove_role(340174198330621952) # Soft
					end
					if event.user.roles.include?(340169246774525952) # If the bot changes team the opposite way it will fail to remove the role. This fixes that issue.
						event.user.remove_role(340169246774525952) # Hard
					end
					if event.user.roles.include?(340470911910281216) # Regular Egg
						event.user.remove_role(340470911910281216) # Regular Egg
					end
				else # The argument was invalid.
					event.respond "I couldn't find that team."
					next
				end
			rescue
				event.respond "I couldn't remove roles."
			end
			if args.sample == "hard-boiled"
				event.user.add_role(340169246774525952) # Hard
				event.user.pm "You have been added to the team of Hard Boiled Eggs :egg:"
			elsif args.sample == "soft-boiled"
				event.user.add_role(340174198330621952) # Soft
				event.user.pm "You have been added to the team of Soft Boiled Eggs :egg:"
			else
				event.respond "I couldn't find that team, but I removed your roles."	
			end
		rescue
			event.respond "I couldn't add you to the team, I might not have enough permission."
		end
	else
		event.respond "This command may only be used on the specified channels. (<#340175912391802880> | <#341297868818350090>)"
	end
end

bot.message do |event|
	if event.channel.id == 340175912391802880 || event.channel.id == 341297868818350090
		unless event.author.roles.include?(340131665382998016)
			event.message.delete
		end
	end
end

bot.command(:prune, min_args: 1, max_args: 1, usage: ".prune <2-100>") do |event, args|
	event.message.delete
	if event.author.roles.include?(340131665382998016) || event.author.roles.include?(340131669354741762)
	i = 0
	begin
		i = Integer(args)
	rescue ArgumentError
		event.respond "#{event.author.mention}, That's not a number."
		next
	end
		if i < 2 || i > 100
			event.respond "#{event.author.mention}, You can only prune messages between 2-100."
			next
		end
		event.channel.prune(i)
		event.respond "#{event.author.mention}, I pruned #{i} message(s)."
	else
		event.respond "#{event.author.mention}, Only Moderators or higher can prune."
	end
end

bot.command(:nsfw) do |event|
	if event.user.roles.include?(341868734002102274) # NSFW
		event.user.remove_role(341868734002102274) # NSFW
		event.respond "You no longer have the NSFW role. :egg:"
	else
		event.user.add_role(341868734002102274) # NSFW
		event.respond "You now have the NSFW role. :egg:"
	end
end

bot.command(:moderator, min_args: 1, max_args: 1) do |event, user|
	if event.author.roles.include?(340131665382998016) # Admin
		user = user[2..-2]
		begin
			tagged_user = bot.member(event.server.id, user);
			if tagged_user.roles.include?(340131669354741762) # Mod
				tagged_user.remove_role(340131669354741762) # Mod
				event.respond "#{event.author.mention}, I removed #{tagged_user.mention}'s Moderator role. :egg:"
			else
				tagged_user.add_role(340131669354741762) # Mod
				event.respond "#{event.author.mention}, I made #{tagged_user.mention} a Moderator. :egg:"
			end
		rescue
			event.respond "That's not a user. Usage: `.moderator @user`"
		end
	else
		event.respond "You're not allowed to add the Moderator role to anyone."
	end
end

trap('INT') do
    exit
end

bot.run 
