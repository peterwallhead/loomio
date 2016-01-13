angular.module('loomioApp').directive 'emojiPicker', ->
  scope: {menuonly: '@'}
  restrict: 'E'
  replace: true
  templateUrl: 'generated/components/emoji_picker/emoji_picker.html'
  controller: ($scope, $timeout, EmojiService, KeyEventService) ->
    $scope.render = EmojiService.render
    $scope.showMenu = $scope.menuonly

    $scope.swapTerm = (term) ->
      $scope.hovered = {}
      $scope.source = if $scope.term
        _.take _.filter(EmojiService.source, (emoji) -> emoji.match $scope.term), 10
      else
        EmojiService.defaults
    $scope.swapTerm('')
    $scope.$watch 'term', $scope.swapTerm

    $scope.toggleMenu = ->
      $scope.showMenu = !$scope.showMenu
      $timeout ->
        if $scope.showMenu
          document.querySelector('.emoji-picker__search').focus()
        else
          document.querySelector('.comment-form__comment-field').focus()

    $scope.hideMenu = ->
      return unless $scope.showMenu
      $scope.hovered = {}
      $scope.term = ''
      $scope.toggleMenu()
    KeyEventService.registerKeyEvent $scope, 'pressedEsc', $scope.toggleMenu, -> $scope.showMenu

    $scope.hover = (emoji) ->
      $scope.hovered =
        name: emoji
        image: $scope.render(emoji)

    $scope.select = (emoji) ->
      $scope.$emit 'emojiSelected', emoji
      $scope.hideMenu()

    $scope.noEmojisFound = ->
      $scope.source.length == 0
