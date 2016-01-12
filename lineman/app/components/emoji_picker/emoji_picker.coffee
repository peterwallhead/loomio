angular.module('loomioApp').directive 'emojiPicker', ->
  restrict: 'E'
  replace: true
  templateUrl: 'generated/components/emoji_picker/emoji_picker.html'
  controller: ($scope, EmojiService) ->
    $scope.render = EmojiService.render

    $scope.swapTerm = (term) ->
      $scope.hovered = {}
      $scope.source = if $scope.term
        _.take _.filter(EmojiService.source, (emoji) -> emoji.match $scope.term), 10
      else
        EmojiService.defaults
    $scope.swapTerm('')
    $scope.$watch 'term', (term) ->
      $scope.swapTerm(term)

    $scope.openMenu = ->
      $scope.showMenu = true

    $scope.hover = (emoji) ->
      $scope.hovered =
        name: emoji
        image: $scope.render(emoji)

    $scope.select = (emoji) ->
      $scope.showMenu = false
      $scope.hovered = {}
      $scope.term = ''
      $scope.$emit 'emojiSelected', emoji

    $scope.noEmojisFound = ->
      $scope.source.length == 0
