surprise = (JEFRi)->
	class surprise
		constructor: ->
			@ENDPOINT = 'http://localhost:3000/'
			JEFRi.ready.then =>
				@load()

		load: ->
			setTimeout (-> _.Event.trigger(@loaded, {})), 100

	new surprise()

angular.module('surprise')
	.factory 'surprise', ['JEFRi', surprise]
