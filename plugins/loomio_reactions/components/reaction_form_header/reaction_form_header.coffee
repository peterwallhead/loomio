angular.module('loomioApp').directive 'reactionFormHeader', ->
  restrict: 'E'
  replace: true
  templateUrl: 'generated/plugins/loomio_reactions/components/reaction_form_header/reaction_form_header.html'
  controller: ($scope, Records, AbilityService) ->

    # TODO: I'm pretty sure 'reaction_form_header' and 'reaction_form_footer' can be the same directive
    # with the same controller and a flexible template
    $scope.$on 'emojiSelected', (event, emoji) ->
      event.stopPropagation()
      emoji = emoji.replace(/:/g, '')
      Records.comments.remote.postMember($scope.comment.id, 'reactions', reaction: emoji).then (data) ->
        reactions = $scope.comment.discussion().reactions
        reactions[$scope.comment.id] = data
        $scope.comment.discussion().update(reactions: reactions)
