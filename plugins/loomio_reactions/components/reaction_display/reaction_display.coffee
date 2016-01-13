angular.module('loomioApp').directive 'reactionDisplay', ->
  restrict: 'E'
  replace: true
  templateUrl: 'generated/plugins/loomio_reactions/components/reaction_display/reaction_display.html'
  controller: ($scope, Records, AbilityService, EmojiService) ->
    $scope.reactions = ->
      ($scope.comment.discussion().reactions || {})[$scope.comment.id]

    $scope.reactionEmojis = ->
      _.keys $scope.reactions()

    $scope.countFor = (reaction) ->
      _.size $scope.reactions()[reaction]

    $scope.emojiFor = (reaction) ->
      EmojiService.render(":#{reaction}:")

    $scope.showReactionForm = ->
      AbilityService.isLoggedIn() and
      _.any($scope.reactions())
