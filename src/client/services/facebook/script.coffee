angular.module('facebook', ['jQuery'])
	.factory 'FB', (jQuery)->
		gAppID = '252548824873861'
		FB.init
			appId: gAppID, 
			status: true,
			cookie: true,
			xfbml: true,
			frictionlessRequests: true,
			useCachedDialogs: true,
			oauth: true

		FB.Event.subscribe 'auth.login', (session)->
			if session and session.status isnt 'not_authorized' and session.authResponse.accessToken
				_.Event.trigger FB.connected, session, FB

		FB.friends = FB.friends || []
		connect = ->
			FB.api '/me/friends', {field: 'name,picture'},(response)->
				unless response.error
					FB.friends = response.data
					_.Event.trigger FB.friendsLoaded, FB.friends, FB
		_.Event.observe FB.connected, connect, FB

		_.Event.observe FB.connected, (-> jQuery "body" .toggleClass "logged-out logged-in"), FB

		FB