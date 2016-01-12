angular.module('loomioApp').directive 'reactionDisplay', ->
  restrict: 'E'
  replace: true
  templateUrl: 'generated/plugins/loomio_reactions/components/reaction_display/reaction_display.html'
  controller: ($scope, Records, EmojiService) ->
    Records.comments.remote.getMember($scope.comment.id, 'reactions').then (data) ->
      $scope.reactions = data

      $scope.emojiFor = (reaction) ->
        EmojiService.render(":#{reaction}:")
