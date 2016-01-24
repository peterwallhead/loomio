angular.module('loomioApp').directive 'reactionFetcher', ->
  restrict: 'E'
  replace: true
  controller: ($scope, Records, MessageChannelService) ->
    Records.discussions.remote.getMember($scope.threadPage.discussion.id, 'reactions').then (data) ->
      $scope.threadPage.discussion.update(reactions: data)

    MessageChannelService.subscribeToDiscussion $scope.threadPage.discussion,
      successFn: (data) -> $scope.$broadcast('reactionReceived', data)
