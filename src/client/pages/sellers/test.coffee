describe "Sellers", !(a)->
	$scope = null

	beforeEach module 'surprise'

	beforeEach inject ['$rootScope', '$controller', !($rootScope, $controller)->
		$scope = $rootScope.$new()
		ctrl = $controller 'Host', {$scope}
	]
