portfolioApp = angular.module('portfolioApp',['smoothScroll','ngRoute','portfolioControllers'])

### App Module ###

portfolioApp.config(['$routeProvider', ($routeProvider)->
  $routeProvider
    .when('/projects/:projectid', { templateUrl: '/partials/project_template.html', controller: 'ProjectCtrl'})
    .when('/index', {templateUrl: '/partials/index_template.html', controller: 'IndexCtrl'})
    .otherwise({redirectTo: '/index'})])

###portfolioApp.run(['$location','$anchorScroll','$routeParams'($scope, $location, $anchorScroll, $routeParams) ->
  $scope.$on('$routeChangeSuccess', (newRoute,oldRoute) ->
    $location.hash($routeParams.scrollTo)
    $anchorScroll()
  )
])###


### Controllers ###

portfolioControllers = angular.module('portfolioControllers',[])

portfolioControllers.controller('ProjectCtrl', ['$scope','$http','$routeParams', ($scope,$http,$routeParams) ->
  $scope.projectid = $routeParams.projectid
  $http.get('projects/'+$routeParams.projectid+'/'+$routeParams.projectid+'.json').success((data) ->
    $scope.project = data
  )]
)

portfolioControllers.controller('IndexCtrl',['$scope','$http',($scope,$http)->
  $http.get('projects/projects.json').success((data)->
    $scope.projects = data # NOTE: data must be an array consisting of subarrays of three projects each. Manually formatted because I'm lazy.
    for row in $scope.projects
      for project in row
        project.thumb = 'projects/'+project.id+'/thumb.jpg'
        # Nested for loops are how you know you're doing it right.
  )
  return])
