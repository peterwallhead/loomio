angular.module('loomioApp').directive 'positionFields', ->
  restrict: 'E'
  replace: true
  templateUrl: 'generated/plugins/position_specific/components/position_fields/position_fields.html'
  controller: ($scope) ->
    $scope.expand = ->
      $scope.expanded = true
