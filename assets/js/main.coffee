@app = new angular.module 'frontexVisualisationApp', []

app
    .directive 'section', ['$rootScope', ($rootScope) ->
        new SectionDirective($rootScope)]

    .directive 'streamVis', ['$compile', ($compile) ->
        new StreamGraphDirective($compile)]

    .directive 'mapVis', ['$compile', ($compile) ->
        new DatamapDirective($compile)]



    .filter 'capFirst', ->
        return (string) -> string.charAt(0).toUpperCase() + string.slice(1);

    .filter 'camelToSpaceCase', ->
        return (string) -> string.replace(/([A-Z]+)*([A-Z][a-z])/g, "$1 $2")

skrollr.init()
