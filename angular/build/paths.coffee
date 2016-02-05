yaml    = require('node-yaml-config')
vendor  = yaml.reload('build/config/vendor.yml')
plugins = yaml.reload('build/config/plugins.yml')
_       = require 'lodash'
include = (key, file) -> _.map(vendor.vendor[key], (file) -> [vendor.vendor.path, file].join('/'))

module.exports =
  core:
    coffee:       'core/**/*.coffee'
    haml:         'core/components/**/*.haml'
    scss:         _.flatten([include('css'), 'core/css/main.scss', 'core/components/**/*.scss'])
    scss_include: _.flatten([include('css_includes'), 'core/css'])
  vendor:
    fonts:        include('fonts')
    js:           include('js')
  plugins:
    coffee:       'plugins/**/*.coffee'
    haml:         'plugins/**/*.haml'
    scss:         'plugins/**/*.scss'
  dist:
    assets:      '../public/assets'
    fonts:       '../public/fonts'
  protractor:
    config:       'test/protractor.coffee',
    screenshots:  'test/protractor/screenshots',
    specs:        'test/protractor/*_spec.coffee'
