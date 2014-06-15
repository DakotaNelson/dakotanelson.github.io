portfolioApp = angular.module('portfolioApp',['smoothScroll','ngRoute','portfolioControllers'])


### Directives ###

portfolioApp.directive('dnShadowbox', ->
  return {
    template: '<a ng-click="openShadowbox()"><div class="thumbnail"><img ng-src="{{imageUrl}}"></div></a>',
    scope: {
      imageName: '@name',
      imageUrl: '@url'
    },
    link: (scope,element,attrs) ->
      scope.openShadowbox = () ->
        Shadowbox.open({
          content: @imageUrl,
          player: 'img',
          gallery: 'Project'
          title: @imageName
        })
  }
)


### App Module ###

portfolioApp.config(['$routeProvider', ($routeProvider)->
  $routeProvider
    .when('/projects/:projectid', { templateUrl: '/partials/project_template.html', controller: 'ProjectCtrl'})
    .when('/index', {templateUrl: '/partials/index_template.html', controller: 'IndexCtrl'})
    .otherwise({redirectTo: '/index'})])


### Controllers ###

portfolioControllers = angular.module('portfolioControllers',[])

portfolioControllers.controller('ProjectCtrl', ['$scope','$http','$routeParams', ($scope,$http,$routeParams) ->
  Shadowbox.init()
  $scope.projectid = $routeParams.projectid
  $http.get('projects/'+$routeParams.projectid+'/'+$routeParams.projectid+'.json').success((data) ->
    $scope.project = data
  )
])

portfolioControllers.controller('IndexCtrl',['$scope','$http',($scope,$http)->
  $http.get('projects/projects.json').success((data)->
    $scope.projects = data # NOTE: data must be an array consisting of subarrays of three projects each. Manually formatted because I'm lazy.
    for row in $scope.projects
      for project in row
        project.thumb = 'projects/'+project.id+'/thumb.jpg'
        # Nested for loops are how you know you're doing it right.
  )
  return])
