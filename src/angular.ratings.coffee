app = angular.module('ratings', [])

app.directive "angularRatings", ->
		restrict: 'E'
		scope: 
			model: '=ngModel' #binds whatever ngModel refrences to $scope.model
			notifyId: '=notifyId'
		replace: true
		transclude: true
		
		template: '<div><ol class="angular-ratings">'+
			'<li ng-class="{active:model>0,over:over>0}">1</li>' +
			'<li ng-class="{active:model>1,over:over>1}">2</li>' +
			'<li ng-class="{active:model>2,over:over>2}">3</li>' +
			'<li ng-class="{active:model>3,over:over>3}">4</li>' +
			'<li ng-class="{active:model>4,over:over>4}">5</li>' +
			'</ol></div>'
		
		# controller
		controller: ['$scope', '$attrs', '$http', ($scope, $attrs, $http) ->
			$scope.over = 0
			
			# accepts a piece of the time and where to put it... 
			$scope.setRating = (rating) ->
				$scope.model = rating
				$scope.$apply()
				
				if $attrs.notifyUrl != undefined && $scope.notifyId
					$http.post($attrs.notifyUrl, {id:$scope.notifyId, rating:rating})
						.error((data)->
							if typeof(data) == 'string'
								alert data
							$scope.model = 0
						)
					
			$scope.setOver = (n) ->
				$scope.over = n
				$scope.$apply()
		]
		
		
		# currently no compilers needed, just the linking function...
		link: (scope, iElem, iAttrs) ->
			
			if iAttrs.notifyUrl != undefined
				# setup event listeners
				angular.forEach iElem.children(), (ol) ->
					angular.forEach ol.children, (li) ->
						li.addEventListener('mouseover', ->
							scope.setOver(parseInt(li.innerHTML))
						)
						li.addEventListener('mouseout', ->
							scope.setOver 0
						)
						li.addEventListener('click', ->
							scope.setRating(parseInt(li.innerHTML))
						)
			
