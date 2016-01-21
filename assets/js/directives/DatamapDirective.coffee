class @DatamapDirective
    constructor: (@$compile) ->
    scope: false

    viewboxes:
        euClose: '490 134 87 89'
        euMiddleEast: '490 160 139 89'
        westernWorld: '330 200 450 89'
    link: (scope, el, attrs) =>

        scope.$watch 'dataset', =>

            map = new Datamap
                fills:
                    defaultFill: scope.getBaseColor 1
                strokes:
                    defaultStroke: scope.getMainColor 1
                geographyConfig:
                    highlightFillColor: scope.getHighlightColor()
                    highlightBorderColor: scope.getHighlightColor()
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

            # highlight interactable countries
            for country in scope.dataset.getCountries()
                countryEl = svg.select '.' + country
                countryEl.style 'fill', scope.getMainColor 1
                countryEl.attr 'ng-click', 'selectCountry("' + country + '")'
                countryEl.classed 'interactable-country', true
                countryEl.attr 'ng-mouseenter', 'hintCountry("' + country + '")'
                countryEl.attr 'ng-mouseleave', 'unhintCountry()'
                @$compile(countryEl[0])(scope) if countryEl[0][0]?

            # highlight hinted countries
            scope.$watch 'hintedCountry', (newCountry,oldCountry) =>
                if oldCountry != ''
                    oldCountryEl = svg.select '.' + oldCountry
                    oldCountryEl.classed 'highlighted', false
                    oldCountryEl.style 'fill', scope.getMainColor 1
                if newCountry != ''
                    newCountryEl = svg.select '.' + newCountry
                    newCountryEl.classed 'highlighted', true
            scope.$watch 'selectedCountry', (newCountry,oldCountry) =>
                console.log 'highlighting'
                if oldCountry != ''
                    oldCountryEl = svg.select '.' + oldCountry
                    oldCountryEl.classed 'highlighted', false
                    oldCountryEl.style 'fill', scope.getMainColor 1
                if newCountry != ''
                    newCountryEl = svg.select '.' + newCountry
                    newCountryEl.classed 'highlighted', true
