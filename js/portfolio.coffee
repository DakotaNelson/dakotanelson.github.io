portfolioApp = angular.module('portfolioApp',['smoothScroll','ngRoute','portfolioControllers'])


### Directives ###

portfolioApp.directive('dnShadowbox', ->
  return {
    restrict: "E",
    template: '<a href="{{imageUrl}}" rel="shadowbox[Project]"><dn-thumb></dn-thumb></a>',
    scope: {
      imageName: '@name',
      imageUrl: '@url'
    },
  }
)

portfolioApp.directive('dnThumb', ->
  return {
    restrict: 'E',
    template: '<div class="thumbnail"><img ng-src="{{imageUrl}}"></div>',
    scope: false, # inherit from parent
    link: (scope, element, attrs) ->
      div = element.children() # the div in the template above
      img = element.children().children() # the img in the template above
      img.on('load', ->
        heightDiff = img.height() - div.height()
        img.css('margin-top',-heightDiff/2)
      )
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

portfolioControllers.controller('ProjectCtrl', ['$sce','$scope','$http','$routeParams', ($sce,$scope,$http,$routeParams) ->
  $scope.projectid = $routeParams.projectid
  $http.get('projects/'+$routeParams.projectid+'/'+$routeParams.projectid+'.json').success((data) ->
    $scope.project = data
    $scope.project.hasPhotos = if data.photos.length > 0 then true else false
    $scope.project.description = $sce.trustAsHtml($scope.project.description)
    # If it's possible to inject JSON, this is now a vulnerability.
  )
  Shadowbox.init()
  ga('send','pageview', {
    'page': '/projects/'+$routeParams.projectid,
    'title': $routeParams.projectid
  })
])

portfolioControllers.controller('IndexCtrl',['$scope','$http','$timeout',($scope,$http,$timeout)->
  $http.get('projects/projects.json').success((data)->
    $scope.projects = data # NOTE: data must be an array consisting of subarrays of three projects each. Manually formatted because I'm lazy.
    for row in $scope.projects
      for project in row
        project.thumb = 'projects/'+project.id+'/thumb.jpg'
        # Nested for loops are how you know you're doing it right.
  )
  ga('send','pageview', {
    'page': '/index.html',
    'title': 'index'
  })
  $timeout( ->
    loadTime = window.performance.timing.domContentLoadedEventEnd- window.performance.timing.navigationStart
    ga('send','timing','index','loadTime',loadTime, {'page':'/index.html','title':'index'})
  ,3000)
  return])
