$(->
	new_match = ->
		$.ajax(
			url: 'https://graph.facebook.com/me/friends'
			dataType: 'json'
			data: 'access_token=AAADhA5sGTqUBAPJnZBoxB8UPWTDziiPGjQHJTK725RcN3UqV4QFtRqMFS2RpAzX8OFWtCJJ91siFuUoOdB3znhzq7JqTKtZAyc6LHq0QZDZD'
			success: (data) ->
				$.ajax(
					type: 'POST'
					url: 'http://localhost:3000/friends'
					data: data
					dataType: 'json'
					success: (data) ->
						console.log(data)
						list = (friend, type) ->
							if typeof friend == 'object'
								console.log(friend.id)
								console.log(friend.name)
								$(".#{type}").append("<input id='users_' name='users[]' type='checkbox' value='#{friend.id}'> #{friend.name}<br/>")
						list friend, 'play_friends' for friend in data.play_friends
						list friend, 'invite_friends' for friend in data.invite_friends

							
				)
		)

	cool1 = ->
		$.ajax(
			url: 'http://localhost:3000/users'
			dataType: 'json'
			type: 'POST'
			data: {
				"user": {
					"username": "knubie"
					"email": "new@email.com"
					"password": "koedagain2"
					"password_confirmation": "koedagain2"
				}
				"commit": "Save"
			}
			success: (data) ->
				console.log(data)
		)

	new_match()

)