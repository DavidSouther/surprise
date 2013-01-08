angular.module 'JEFRi', []
	.factory 'JEFRi', ->
		rt = new window.JEFRi.Runtime do
			debug: 
				context:
					entities:
						Host:
							key: 'host_id'
							properties:
								host_id:
									type: 'string'
								hostname:
									type: 'string'
								ip:
									type: 'string'
								mac:
									type: 'string'
								router_id:
									type: 'string'
							relationships:
								router:
									type: 'has_a'
									property: 'router_id'
									to:
										type: 'Router'
										property: 'router_id'
									back: 'hosts'
						Router:
							key: 'router_id'
							properties:
								router_id:
									type: 'string'
								name:
									type: 'string'
								gateway:
									type: 'string'
								mask:
									type: 'string'
							relationships:
								hosts:
									type: 'has_many'
									property: 'router_id'
									to:
										type: 'Host'
										property: 'router_id'
									back: 'router'

		JEFRi.Runtime.prototype.run = (which, ents)->
				t = new window.JEFRi.Transaction()
				t.add ents
				storeOptions = {runtime: @}
				s = new window.JEFRi.Stores.ObjectStore storeOptions
				s.execute which, t

		JEFRi.Runtime.prototype.save = (ents)->
				@run 'persist', ents

		JEFRi.Runtime.prototype.get = (spec={})->
				@run 'get', spec

		JEFRi.Runtime.prototype.config = (endpoint="/")->
				@settings.ENDPOINT = endpoint
				return

		rt.settings = { ENDPOINT: "/" }
		rt