portfolioApp = angular.module('portfolioApp',[])

portfolioApp.controller('ProjectCtrl', ($scope,$http) ->
  $http.get('projects/projects.json').success((data) ->
    $scope.project = data
  )
)
