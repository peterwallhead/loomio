angular.module('loomioApp').directive 'reactionFormFooter', ->
  restrict: 'E'
  replace: true
  templateUrl: 'generated/plugins/loomio_reactions/components/reaction_form_footer/reaction_form_footer.html'
  controller: ($scope, Records, ReactionService) ->

    $scope.$on 'emojiSelected', (event, emoji) ->
      event.stopPropagation()
      emoji = emoji.replace(/:/g, '')
      Records.comments.remote.postMember($scope.comment.id, 'reactions', reaction: emoji).then (data) ->
        # ReactionService.updateCommentReactions($scope.comment, data)
