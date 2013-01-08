describe "Deployman service", ->
	service = null

	beforeEach module 'surprise'

	beforeEach inject ['surprise', !(surprise)->
		service := surprise
	]

	beforeEach ->
		@addMatchers do
			toBeArray: ->
				_(@actual).isArray()
