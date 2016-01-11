@app = new angular.module 'frontexVisualisationApp', []

app
    .directive 'section', ->
        new SectionDirective()

    .directive 'streamVis', ['$compile', ($compile) ->
        new StreamGraphDirective($compile)]

    .directive 'mapVis', ->
        new DatamapDirective()
