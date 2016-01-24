angular.module('loomioApp').directive 'reactionDisplay', ->
  restrict: 'E'
  replace: true
  templateUrl: 'generated/plugins/loomio_reactions/components/reaction_display/reaction_display.html'
  controller: ($scope, Records, AbilityService, EmojiService) ->
    $scope.react = (reaction) ->
      Records.comments.remote.postMember($scope.comment.id, 'reactions', reaction: reaction).then (data) ->
        reactions = $scope.discussionReactions()
        _.extend reactions[$scope.comment.id], data.reactions
        $scope.comment.discussion().update(reactions: reactions)

    $scope.discussionReactions = ->
      $scope.comment.discussion().reactions || {}

    $scope.reactions = ->
      $scope.discussionReactions()[$scope.comment.id]

    $scope.reactionEmojis = ->
      _.keys $scope.reactions()

    $scope.countFor = (reaction) ->
      _.size $scope.reactions()[reaction]

    $scope.emojiFor = (reaction) ->
      EmojiService.render(":#{reaction}:")

    $scope.showReactionForm = ->
      AbilityService.isLoggedIn() and
      _.any($scope.reactions())
