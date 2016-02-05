yaml    = require('node-yaml-config')
vendor  = yaml.reload('build/config/vendor.yml')
plugins = yaml.reload('build/config/plugins.yml') or {}
_       = require 'lodash'
include = (file, key) ->
  _.map(file[key], (path) -> [file.path, path].join('/'))

module.exports =
  core:
    coffee:       'core/**/*.coffee'
    haml:         'core/components/**/*.haml'
    scss:         _.flatten([include(vendor, 'css'), 'core/css/main.scss', 'core/components/**/*.scss'])
    scss_include: _.flatten([include(vendor, 'css_includes'), 'core/css'])
  vendor:
    fonts:        include(vendor, 'fonts')
    js:           include(vendor, 'js')
  plugins:
    coffee:       include(plugins, 'coffee')
    haml:         include(plugins, 'haml')
    scss:         include(plugins, 'scss')
  dist:
    fonts:       '../public/client/fonts'
    assets:      '../public/client/development'
  protractor:
    config:       'test/protractor.coffee',
    screenshots:  'test/protractor/screenshots',
    specs:        'test/protractor/*_spec.coffee'
