angular.module('loomioApp').directive 'reactionForm', ->
  restrict: 'E'
  replace: true
  templateUrl: 'generated/plugins/loomio_reactions/components/reaction_form/reaction_form.html'
  controller: ($scope, Records) ->

    Records.comments.remote.getMember($scope.comment.id, 'reactions').then (data) ->
      $scope.reactions = data
