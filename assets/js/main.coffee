@app = new angular.module 'frontexVisualisationApp', []

app
    .directive 'section', ['$rootScope', ($rootScope) ->
        new SectionDirective($rootScope)]

    .directive 'streamVis', ['$compile', ($compile) ->
        new StreamGraphDirective($compile)]

    .directive 'mapVis', ['$compile', ($compile) ->
        new DatamapDirective($compile)]
