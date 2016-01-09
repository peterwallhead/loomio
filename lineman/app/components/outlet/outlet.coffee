angular.module('loomioApp').directive 'outlet', ($compile) ->
  restrict: 'E'
  replace: true
  link: (scope, elem, attrs) ->
    if window.Loomio.plugins.activeOutlets[_.snakeCase(attrs.name)]
      elem.append $compile("<#{_.snakeCase(attrs.name)} />")(scope)
