angular.module('loomioApp').directive 'pekingDoge', ($timeout) ->
  restrict: 'E'
  replace: true
  templateUrl: 'generated/plugins/peking_doge/components/peking_doge/peking_doge.html'
  controller: ($scope, $timeout) ->
    $timeout (-> $scope.visible = true), 5000

    $scope.setClicked = ->
      delay(1, 750)
      delay(2, 1500)
      delay(3, 2250)
      delay(4, 3000)

    delay = (n, time) ->
      $timeout (-> $scope["clicked#{n}"] = true), time
