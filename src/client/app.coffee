curry = (f) -> (x) -> (y)-> (f x, y)
angular.classmap = curry (module, map)->
	for clas, list of map
		do (clas, list) ->
			directive = ->
				restrict: 'C'
				link: (scope, $el) ->
					$el.addClass list

			angular.module(module)
				.directive clas, directive
	return

angular.classes = angular.classmap 'ng'

angular.module('ng')
	.run ($rootScope)->
		$rootScope.$sapply = -> @$apply() unless @$$phase

jQuery.template = (tplSel)->
	jQuery("#templates #{tplSel}").html()

# The surprise app is a typical single-page web application.
# It depends on our common libraries, and configures some routes.
angular.module 'surprise', ['JEFRi', 'jQuery', 'ui'], ($routeProvider)->
	$routeProvider
		.when('/', {template: jQuery.template '#sellers'})
		.when('/sellers', {template: jQuery.template '#sellers'})
	return

# A variety of bootstrap classes for our semantic classes.
angular.classes
	navDrop: "btn btn-navbar"
	menu: "navbar navbar-inverse navbar-fixed-top"
	content: "container"
	table: "table-striped"
