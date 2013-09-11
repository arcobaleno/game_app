module FriendshipsHelper

#Return an appropriate friendship status message.
	def friendship_status(user, friend)
		friendship = Friendship.find_by_user_id_and_friend_id(user, friend)
		return "#{full_name(friend)} is not yet your friend." if friendship.nil?
		case friendship.status
		when 'requested'
			"#{full_name(friend)} would like to be your friend."
		when 'pending'
			"You have requested friendship from #{full_name(friend)}."
		when 'accepted'
			"#{full_name(friend)} is your friend."
		end
	end

	#Return true if hiding the edit links for spec, etc.
	def hide_edit_links?
		not @hide_edit_links.nil?
	end

	def profile_for(user)
		url_for(user)
	end
end
