axis         = require 'axis'
rupture      = require 'rupture'
autoprefixer = require 'autoprefixer-stylus'
js_pipeline  = require 'js-pipeline'
css_pipeline = require 'css-pipeline'

module.exports =
  ignores: ['readme.md', '**/layout.*', '**/_*', '.gitignore', 'ship.*conf']

  extensions: [
    js_pipeline(files: [
        'node_modules/topojson/topojson.js',
        'node_modules/datamaps/dist/datamaps.all.js',

        'assets/js/prepare.coffee'
        'assets/js/statistics/*.js'

        'assets/js/map/*.coffee'
        'assets/js/graphs/*.coffee'

        'assets/js/main.coffee'
        'node_modules/d3/d3.js',
        'node_modules/angular/angular.js'
        ]
        ),
    css_pipeline(files: 'assets/css/*.styl')
  ]

  stylus:
    use: [axis(), rupture(), autoprefixer()]
    sourcemap: true

  'coffee-script':
    sourcemap: true

  jade:
    pretty: true
