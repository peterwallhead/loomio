yaml    = require('node-yaml-config')
vendor  = yaml.reload('build/config/vendor.yml')
_       = require 'lodash'

plugins = try
  yaml.reload('build/config/plugins.yml')
catch
  {}

include = (file, key) ->
  _.map(file[key], (path) -> [file.path, path].join('/'))

module.exports =
  core:
    coffee:       _.flatten(['core/**/*.coffee', include(plugins, 'coffee')])
    haml:         _.flatten(['core/components/**/*.haml', include(plugins, 'haml')])
    scss:         _.flatten([include(vendor, 'css'), 'core/css/main.scss', 'core/components/**/*.scss', include(plugins, 'scss')])
    scss_include: _.flatten([include(vendor, 'css_includes'), 'core/css'])
  vendor:
    fonts:        include(vendor, 'fonts')
    js:           include(vendor, 'js')
  dist:
    fonts:       '../public/client/fonts'
    assets:      '../public/client/development'
  protractor:
    config:       'test/protractor.coffee',
    screenshots:  'test/protractor/screenshots',
    specs:        'test/protractor/*_spec.coffee'
