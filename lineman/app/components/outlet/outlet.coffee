angular.module('loomioApp').directive 'outlet', ($controller) ->
  scope: {}
  controller: '@'
  name: 'controllerName'
  restrict: 'E'
  template: '<div><div ng-include="outletContent"></div></div>'
  replace: true
  link: (scope, elem, attrs) ->
    scope.outletContent = "generated/components/after_sign_in/after_sign_in.html"
