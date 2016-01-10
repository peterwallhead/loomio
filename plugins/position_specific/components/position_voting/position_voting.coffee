angular.module('loomioApp').directive 'positionVoting', ->
  restrict: 'E'
  replace: true
  templateUrl: 'generated/plugins/position_specific/components/position_voting/position_voting.html'
  controller: ($scope, Records) ->
    $scope.descriptions = {}

    Records.proposals.remote.getMember($scope.proposal.id, 'descriptions').then (data) ->
      $scope.descriptions = data

    $scope.hasDescriptions = ->
      _.any _.keys $scope.descriptions
