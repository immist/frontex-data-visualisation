axis         = require 'axis'
rupture      = require 'rupture'
autoprefixer = require 'autoprefixer-stylus'
js_pipeline  = require 'js-pipeline'
css_pipeline = require 'css-pipeline'

module.exports =
  ignores: ['readme.md', '**/layout.*', '**/_*', '.gitignore', 'ship.*conf']

  extensions: [
    js_pipeline
        files: [
            'assets/js/prepare.coffee'
            'assets/js/statistics/*.js'

            'assets/js/libs/d3.js',
            'assets/js/libs/angular.js'
            'assets/js/libs/ngParallax.js'

            'assets/js/libs/topojson.js',
            'assets/js/libs/datamaps.all.js',

            'assets/js/directives/*.coffee'

            'assets/js/main.coffee'
        ]
        ,
    css_pipeline(files: 'assets/css/*.styl')
  ]

  stylus:
    use: [axis(), rupture(), autoprefixer()]
    sourcemap: true

  'coffee-script':
    sourcemap: true

  jade:
    pretty: true
