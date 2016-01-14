class @DatamapDirective
    constructor: (@$compile) ->
    scope: false

    viewboxes:
        euClose: '469 134 87 89'
        euMiddleEast: '447 160 139 89'
    link: (scope, el, attrs) =>

        scope.$watch 'dataset', =>

            map = new Datamap
                fills:
                    defaultFill: scope.getBaseColor 1
                    highlightFillColor: 'blue'
                strokes:
                    defaultStroke: scope.getMainColor 1
                geographyConfig:
                    highlightFillColor: scope.getHighlightColor()
                    highlightBorderColor: scope.getMainColor 3
                    borderColor: scope.getBaseColor 2

                element: el[0]
                setProjection: (element, options) ->
                    projection = d3.geo.stereographic()
                    path = d3.geo.path()
                        .projection( projection )
                    return {path: path, projection: projection}
                svg = d3.select(el[0])
            svg = svg.select 'svg'

            viewbox = if scope.focus? then @viewboxes[scope.focus] else @viewboxes['euClose']
            svg.attr 'viewBox', viewbox

            for country in scope.dataset.getCountries()
                countryEl = svg.select '.' + country
                countryEl.style 'fill', scope.getMainColor 3
                countryEl.attr 'ng-click', 'selectCountry("' + country + '")'
                @$compile(countryEl[0])(scope) if countryEl[0][0]?
                countryEl.attr 'ng-mouseenter', 'hintCountry("' + country + '")'
                countryEl.attr 'ng-mouseleave', 'unhintCountry()'
                @$compile(countryEl[0])(scope) if countryEl[0][0]?
