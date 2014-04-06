portfolioApp = angular.module('portfolioApp',['ngRoute','portfolioControllers'])

### App Module ###

portfolioApp.config(['$routeProvider', ($routeProvider)->
  $routeProvider
    .when('/projects/:projectid', { templateUrl: '/partials/project_template.html', controller: 'ProjectCtrl'})
    .when('/index', {templateUrl: '/partials/index_template.html', controller: 'IndexCtrl'})
    .otherwise({redirectTo: '/index'})])


### Controllers ###

portfolioControllers = angular.module('portfolioControllers',[])

portfolioControllers.controller('ProjectCtrl', ['$scope','$http','$routeParams', ($scope,$http,$routeParams) ->
  $scope.projectid = $routeParams.projectid
  console.log($scope.projectid)
  $http.get('projects/projects.json').success((data) ->
    $scope.project = data
  )]
)

portfolioControllers.controller('IndexCtrl',[($scope)-> return])
