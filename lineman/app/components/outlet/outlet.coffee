angular.module('loomioApp').directive 'outlet', ->
  scope: {name: '@'}
  restrict: 'E'
  template: '<div ng-include="outletContent">'
  controller: 'AfterSignInController'
  replace: true
  link: (scope, elem, attrs) ->
    scope.outletContent = "generated/components/#{scope.name}/#{scope.name}.html"
