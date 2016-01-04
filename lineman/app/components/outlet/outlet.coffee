angular.module('loomioApp').directive 'outlet', ($controller) ->
  scope: {outletContent: '@'}
  controller: '@'
  name: 'controllerName'
  restrict: 'E'
  template: '<div><div ng-include="outletContent"></div></div>'
  replace: true
  compile: (elem, attrs) ->
    outletName = _.snakeCase(attrs.controllerName)
    if pluginName = window.Loomio.plugins.activeOutlets[outletName]
      attrs.outletContent = "generated/plugins/#{pluginName}/components/#{outletName}/#{outletName}.html"
    else
      window.Loomio.plugins.stubOutlet(outletName)
