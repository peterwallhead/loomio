angular.module('loomioApp').directive 'reactionFetcher', ->
  restrict: 'E'
  replace: true
  controller: ($scope, Records) ->
    Records.discussions.remote.getMember($scope.threadPage.discussion.id, 'reactions').then (data) ->
      $scope.threadPage.discussion.update(reactions: data)
