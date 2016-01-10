app = new angular.module 'frontexVisualisationApp', []

app.directive 'stream-vis', ['$compile', ($compile) ->
    new StreamGraph($compile)]

app.directive 'map-vis', ($compile) ->
    new DatamapDirective()
