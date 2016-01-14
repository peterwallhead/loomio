angular.module('loomioApp').directive 'reactionFormFooter', ->
  restrict: 'E'
  replace: true
  templateUrl: 'generated/plugins/loomio_reactions/components/reaction_form_footer/reaction_form_footer.html'
  controller: ($scope, Records, AbilityService) ->

    $scope.$on 'emojiSelected', (event, emoji) ->
      event.stopPropagation()
      emoji = emoji.replace(/:/g, '')
      Records.comments.remote.postMember($scope.comment.id, 'reactions', reaction: emoji).then (data) ->
        reactions = $scope.comment.discussion().reactions
        reactions[$scope.comment.id] = data
        $scope.comment.discussion().update(reactions: reactions)
