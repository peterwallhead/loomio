angular.module('loomioApp').directive 'emojiPicker', ->
  restrict: 'E'
  replace: true
  templateUrl: 'generated/components/emoji_picker/emoji_picker.html'
  controller: ($scope, $timeout) ->
    $scope.render = window.Loomio.emojis.render

    $scope.swapTerm = (term) ->
      $scope.searching = true
      $scope.source = if $scope.term
        _.take _.filter(window.Loomio.emojis.source, (emoji) -> emoji.match $scope.term), 10
      else
        _.take window.Loomio.emojis.source, 100
      $scope.searching = false
    $scope.swapTerm('')
    $scope.$watch 'term', (term) ->
      $timeout ->
        $scope.swapTerm(term)

    $scope.openMenu = ->
      $scope.showMenu = true

    $scope.select = (emoji) ->
      $scope.showMenu = false
      $scope.term = ''
      $scope.$emit 'emojiSelected', emoji
