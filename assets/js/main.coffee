@app = new angular.module 'frontexVisualisationApp', []

app
    .directive 'section', ->
        new SectionDirective()

    .directive 'stream-vis', ['$compile', ($compile) ->
        new StreamGraph($compile)]

    .directive 'map-vis', ->
        new DatamapDirective()
