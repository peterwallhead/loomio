gulp     = require 'gulp'
paths    = require './build/paths'
sequence = require 'gulp-run-sequence'

gulp.task 'fonts',  require('./build/fonts')
gulp.task 'app',    require('./build/app')
gulp.task 'vendor', require('./build/vendor')
gulp.task 'scss',   require('./build/scss')

gulp.task 'compile', ['fonts', 'app','vendor','scss']

gulp.task 'dev', -> sequence('compile', require('./build/watch'))

gulp.task 'protractor:now', require('./build/protractor')
gulp.task 'protractor', -> sequence('compile', 'protractor:now')
