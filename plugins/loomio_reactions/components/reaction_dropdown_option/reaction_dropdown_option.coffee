angular.module('loomioApp').directive 'reactionDropdownOption', ->
  restrict: 'E'
  replace: true
  templateUrl: 'generated/plugins/loomio_reactions/components/reaction_dropdown_option/reaction_dropdown_option.html'
  controller: ($scope, AbilityService) ->
    $scope.showReactionForm = ->
      AbilityService.isLoggedIn()
