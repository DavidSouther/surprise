host = (scope, surprise)->
	_.Event.observe surprise.loaded, (-> scope.$sapply())

angular.module 'surprise'
	.controller 'Host', ['$scope', 'surprise', 'JEFRi', host]

angular.classes
	title: "hero-unit"
	hostTable: "table table-striped"
	create: "btn btn-primary"
	remove: "btn"